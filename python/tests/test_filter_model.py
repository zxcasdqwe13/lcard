import contextlib
import io
import json
import tempfile
import unittest
from pathlib import Path

from e440.cli import main
from e440.filter_model import (
    ACC_MAX,
    FilterCapture,
    FilterModel,
    FilterModelConfig,
    accumulator_to_word,
    compare_signals,
    estimate_bandwidth,
    load_capture,
    search_model,
)
from e440.filter_test import (
    MockLoopConfig,
    analyze_capture,
    auto_analyze,
    make_mock_capture,
    run_mock_test,
)

ZERO_FIR = [0] * 64
ZERO_IIR = [0] * 8


class FilterModelTests(unittest.TestCase):
    def test_passthrough_uses_unsigned_b0(self):
        config = FilterModelConfig(
            ntaps=0,
            n2taps=0,
            b0=0x8000,
            fir_coefs=ZERO_FIR,
            iir_coefs=ZERO_IIR,
        )
        samples = [-1000, 0, 1000, 32767, -32768]
        self.assertEqual(FilterModel(config).simulate(samples), samples)

    def test_fir_impulse_response(self):
        config = FilterModelConfig(
            ntaps=1,
            n2taps=0,
            b0=0,
            fir_coefs=[0x4000] + ZERO_FIR[1:],
            iir_coefs=ZERO_IIR,
            fir_delay=1,
            fir_step=1,
            round_initial=False,
        )
        output = FilterModel(config).simulate([1000, 0, 0, 0])
        self.assertEqual(output, [0, 500, 0, 0])

    def test_fir_coefficient_order(self):
        config = FilterModelConfig(
            ntaps=2,
            n2taps=0,
            b0=0,
            fir_coefs=[0x4000, 0x2000] + ZERO_FIR[2:],
            iir_coefs=ZERO_IIR,
            fir_delay=1,
            fir_step=1,
            round_initial=False,
        )
        output = FilterModel(config).simulate([1000, 0, 0, 0])
        self.assertEqual(output[:4], [0, 500, 250, 0])

    def test_iir_impulse_response(self):
        config = FilterModelConfig(
            ntaps=0,
            n2taps=1,
            b0=0x8000,
            fir_coefs=ZERO_FIR,
            iir_coefs=[0x4000] + ZERO_IIR[1:],
            iir_delay=1,
            iir_step=1,
        )
        output = FilterModel(config).simulate([1000, 0, 0, 0, 0])
        self.assertEqual(output, [1000, -500, 250, -125, 62])

    def test_accumulator_words(self):
        acc = 0x12348000
        self.assertEqual(accumulator_to_word(acc, "mr1"), 0x1234)
        self.assertEqual(accumulator_to_word(acc, "mr0"), -32768)
        with self.assertRaises(ValueError):
            accumulator_to_word(acc, "bad")  # type: ignore[arg-type]

    def test_saturation(self):
        config = FilterModelConfig(
            ntaps=2,
            n2taps=1,
            b0=0x7FFF,
            fir_coefs=[0x7FFF, 0x7FFF] + ZERO_FIR[2:],
            iir_coefs=ZERO_IIR,
            fir_delay=1,
            fir_step=1,
            round_initial=False,
        )
        raw_config = FilterModelConfig(
            ntaps=config.ntaps,
            n2taps=config.n2taps,
            b0=config.b0,
            fir_coefs=config.fir_coefs,
            iir_coefs=config.iir_coefs,
            fir_delay=config.fir_delay,
            fir_step=config.fir_step,
            round_initial=False,
            saturate=False,
        )
        self.assertGreater(
            FilterModel(raw_config).accumulator([32767, 32767], [0, 0], 1),
            ACC_MAX,
        )
        model = FilterModel(config)
        self.assertEqual(model.accumulator([32767, 32767], [0, 0], 1), ACC_MAX)
        output = model.simulate([32767, 32767])
        self.assertEqual(output[1], 32767)

    def test_zero_iir_equals_fir(self):
        fir_config = FilterModelConfig(
            ntaps=3,
            n2taps=0,
            b0=0x4000,
            fir_coefs=[0x2000, -0x1000, 0x0800] + ZERO_FIR[3:],
            iir_coefs=ZERO_IIR,
            fir_delay=2,
            fir_step=2,
        )
        iir_config = fir_config.with_delays(iir_delay=1)
        samples = [100, -200, 300, -400, 500, -600, 700]
        self.assertEqual(
            FilterModel(fir_config).simulate(samples),
            FilterModel(iir_config).simulate(samples),
        )

    def test_mixed_words_require_free_run(self):
        config = FilterModelConfig(
            ntaps=0,
            n2taps=1,
            b0=0x8000,
            fir_coefs=ZERO_FIR,
            iir_coefs=[0x4000] + ZERO_IIR[1:],
            iir_delay=1,
            iir_step=1,
            word="mr0",
            output_word="mr1",
        )
        model = FilterModel(config)
        output = model.simulate([1000, 0, 0, 0])
        self.assertEqual(len(output), 4)
        with self.assertRaises(ValueError):
            model.predict_sequence([0, 0, 0, 0], [0, 0, 0, 0])

    def test_requires_valid_delays(self):
        with self.assertRaises(ValueError):
            FilterModelConfig(iir_delay=0)
        with self.assertRaises(ValueError):
            FilterModelConfig(fir_step=0)

    def test_from_filter_config(self):
        from e440.dsp import FilterConfig

        device_config = FilterConfig(
            ntaps=4,
            n2taps=3,
            fir_coef1=[0x2000] + ZERO_FIR[1:],
            iir_coefs=[0x1000] + ZERO_IIR[1:],
            decimation=5,
            channels=2,
        )
        model_config = FilterModelConfig.from_filter_config(
            device_config, fir_delay=2, iir_delay=1
        )
        self.assertEqual(model_config.ntaps, 4)
        self.assertEqual(model_config.n2taps, 3)
        self.assertEqual(model_config.decimation, 5)
        self.assertEqual(model_config.fir_coefs[0], 0x2000)
        self.assertEqual(model_config.iir_coefs[0], 0x1000)


class SpectralTests(unittest.TestCase):
    def test_sine_bandwidth(self):
        try:
            import numpy as np
        except ImportError:
            self.skipTest("numpy is not installed")
        rate = 100_000
        time = np.arange(rate // 10) / rate
        samples = (10_000 * np.sin(2 * np.pi * 1_000 * time)).astype(int)
        bandwidth = estimate_bandwidth(samples.tolist(), rate)
        self.assertIsNotNone(bandwidth)
        assert bandwidth is not None
        self.assertAlmostEqual(bandwidth, 1_000, delta=250)

    def test_constant_input_has_no_bandwidth(self):
        self.assertIsNone(estimate_bandwidth([5] * 100, 100_000))


class ComparisonTests(unittest.TestCase):
    def test_linear_gain_is_removed(self):
        device = [10, 20, 30, 40]
        model = [20, 40, 60, 80]
        result = compare_signals(device, model)
        self.assertAlmostEqual(result.gain, 0.5)
        self.assertAlmostEqual(result.bias, 0.0)
        self.assertAlmostEqual(result.rmse, 0.0)
        self.assertAlmostEqual(result.correlation, 1.0)
        self.assertTrue(result.passed)

    def test_poor_match_fails(self):
        device = [10, 20, 30, 40]
        model = [40, 10, 30, 20]
        result = compare_signals(device, model, min_correlation=0.99)
        self.assertLess(result.correlation, 0.99)
        self.assertFalse(result.passed)

    def test_start_skips_warmup(self):
        device = [9999, 1, 2, 3, 4]
        model = [0, 1, 2, 3, 4]
        result = compare_signals(device, model, start=1)
        self.assertAlmostEqual(result.rmse, 0.0)
        self.assertEqual(result.samples, 4)


class SearchTests(unittest.TestCase):
    def test_recovers_delay_and_word(self):
        true_config = FilterModelConfig(
            ntaps=4,
            n2taps=3,
            b0=0x8000,
            fir_coefs=[0x2000, 0x1000, 0, 0] + ZERO_FIR[4:],
            iir_coefs=[0x1000, 0, 0] + ZERO_IIR[3:],
            fir_delay=4,
            fir_step=2,
            iir_delay=2,
            iir_step=2,
            word="mr1",
        )
        adc = [((index * 7919) % 20000) - 10000 for index in range(200)]
        dac = FilterModel(true_config).simulate(adc)

        base = true_config.with_delays(fir_delay=2, iir_delay=1, word="mr0")
        best = search_model(
            adc,
            dac,
            base,
            fir_delays=[2, 3, 4, 5],
            iir_delays=[1, 2, 3],
            words=("mr1", "mr0"),
        )
        self.assertEqual(best.config.fir_delay, 4)
        self.assertEqual(best.config.iir_delay, 2)
        self.assertEqual(best.config.word, "mr1")
        self.assertGreater(best.comparison.correlation, 0.999)


class CaptureTests(unittest.TestCase):
    def test_csv_with_header(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "capture.csv"
            path.write_text(
                "adc0,adc1,dac\n"
                "1,2,3\n"
                "4,5,6\n"
                "7,8,9\n",
                encoding="utf-8",
            )
            capture = load_capture(path)
            self.assertEqual(capture.samples, 3)
            self.assertEqual(capture.channel(0), [1, 4, 7])
            self.assertEqual(capture.channel(1), [2, 5, 8])
            self.assertEqual(capture.dac, [3, 6, 9])
            adc, feedback = capture.input_output(0, 1)
            self.assertEqual(adc, [1, 4, 7])
            self.assertEqual(feedback, [2, 5, 8])
            adc, dac = capture.input_output(0, 1, prefer_dac_column=True)
            self.assertEqual(adc, [1, 4, 7])
            self.assertEqual(dac, [3, 6, 9])

    def test_csv_without_header(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "capture.dat"
            path.write_text("1 2 3\n4 5 6\n", encoding="utf-8")
            capture = load_capture(path, channels=2)
            self.assertEqual(capture.channel(0), [1, 4])
            self.assertEqual(capture.channel(1), [2, 5])
            self.assertEqual(capture.dac, [3, 6])

    def test_npy_interleaved(self):
        try:
            import numpy as np
        except ImportError:
            self.skipTest("numpy is not installed")
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "capture.npy"
            np.save(path, np.array([1, 2, 3, 4, 5, 6], dtype=np.int16))
            capture = load_capture(path, channels=2)
            self.assertEqual(capture.channel(0), [1, 3, 5])
            self.assertEqual(capture.channel(1), [2, 4, 6])

    def test_npz_metadata(self):
        try:
            import numpy as np
        except ImportError:
            self.skipTest("numpy is not installed")
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "capture.npz"
            np.savez(
                path,
                adc=np.array([[1, 2], [3, 4]], dtype=np.int16),
                ntaps=4,
                n2taps=3,
                decimation=2,
                fir_coefs=np.array([0x2000, 0x1000], dtype=np.uint16),
                iir_coefs=np.array([0x1000], dtype=np.uint16),
            )
            capture = load_capture(path, channels=2)
            self.assertEqual(capture.metadata["ntaps"], 4)
            self.assertEqual(capture.metadata["n2taps"], 3)
            self.assertEqual(capture.metadata["decimation"], 2)
            self.assertEqual(capture.metadata["fir_coefs"], [0x2000, 0x1000])
            self.assertEqual(capture.metadata["iir_coefs"], [0x1000])

    def test_signed_conversion(self):
        capture = FilterCapture([[0xFFFF, 0x8000, 0x7FFF]])
        self.assertEqual(capture.channel(0), [-1, -32768, 32767])

    def test_json(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "capture.json"
            path.write_text(
                json.dumps({"adc": [[1, 2], [3, 4]], "dac": [5, 6]}),
                encoding="utf-8",
            )
            capture = load_capture(path)
            self.assertEqual(capture.channel(0), [1, 2])
            self.assertEqual(capture.channel(1), [3, 4])
            self.assertEqual(capture.dac, [5, 6])


class MockLoopTests(unittest.TestCase):
    def setUp(self):
        self.config = FilterModelConfig(
            ntaps=4,
            n2taps=3,
            fir_coefs=[0x2000, 0x1000, 0, 0] + ZERO_FIR[4:],
            iir_coefs=[0x1000, 0, 0] + ZERO_IIR[3:],
            fir_delay=2,
            fir_step=2,
            iir_delay=1,
            iir_step=2,
        )

    def test_exact_mock(self):
        result = run_mock_test(
            self.config,
            MockLoopConfig(samples=1000, noise_amplitude=4000, analog_noise=0),
        )
        self.assertTrue(result.comparison.passed)
        self.assertAlmostEqual(result.comparison.correlation, 1.0)
        self.assertAlmostEqual(result.comparison.rmse, 0.0)

    def test_noisy_mock(self):
        result = run_mock_test(
            self.config,
            MockLoopConfig(samples=2000, noise_amplitude=4000, analog_noise=100),
        )
        self.assertTrue(result.comparison.passed)
        self.assertGreater(result.comparison.correlation, 0.99)
        self.assertLess(result.comparison.nrmse, 0.05)

    def test_loop_scale_and_bias(self):
        loop = MockLoopConfig(
            samples=2000,
            noise_amplitude=4000,
            dac_gain=0.5,
            loop_gain=3.0,
            bias=3.0,
        )
        result = run_mock_test(self.config, loop)
        self.assertTrue(result.comparison.passed)
        self.assertAlmostEqual(result.history_scale, 1.5)
        self.assertLess(result.comparison.nrmse, 0.001)

    def test_auto_analyze_detects_mixed_path(self):
        config = FilterModelConfig(
            ntaps=4,
            n2taps=3,
            fir_coefs=[0x2000, 0x1000, 0, 0] + ZERO_FIR[4:],
            iir_coefs=[0x1000, 0, 0] + ZERO_IIR[3:],
            fir_delay=2,
            fir_step=2,
            iir_delay=1,
            iir_step=2,
            word="mr0",
            output_word="mr1",
        )
        capture = make_mock_capture(
            config,
            MockLoopConfig(samples=1000, noise_amplitude=4000, analog_noise=0),
        )
        result = auto_analyze(capture, config, prefer_dac_column=True)
        self.assertEqual(result.config.word, "mr0")
        self.assertEqual(result.config.output_word, "mr1")
        self.assertEqual(result.mode, "free_run")
        self.assertAlmostEqual(result.comparison.rmse, 0.0)

    def test_mixed_word_mock_free_run(self):
        config = FilterModelConfig(
            ntaps=4,
            n2taps=3,
            fir_coefs=[0x2000, 0x1000, 0, 0] + ZERO_FIR[4:],
            iir_coefs=[0x1000, 0, 0] + ZERO_IIR[3:],
            fir_delay=2,
            fir_step=2,
            iir_delay=1,
            iir_step=2,
            word="mr0",
            output_word="mr1",
        )
        result = run_mock_test(
            config,
            MockLoopConfig(samples=1000, noise_amplitude=4000, analog_noise=0),
        )
        self.assertTrue(result.comparison.passed)
        self.assertAlmostEqual(result.comparison.rmse, 0.0)

    def test_analyze_capture_uses_feedback_channel(self):
        capture = make_mock_capture(
            self.config,
            MockLoopConfig(samples=500, noise_amplitude=4000),
        )
        result = analyze_capture(capture, self.config)
        self.assertTrue(result.comparison.passed)


class FilterCliTests(unittest.TestCase):
    def test_filter_test_mock(self):
        output = io.StringIO()
        with contextlib.redirect_stdout(output):
            code = main(
                [
                    "filter-test",
                    "--mock",
                    "--samples",
                    "1500",
                    "--ntaps",
                    "4",
                    "--n2taps",
                    "3",
                    "--decimation",
                    "2",
                    "--analog-noise",
                    "50",
                ]
            )
        self.assertEqual(code, 0, output.getvalue())
        self.assertIn("IIR filter model test: PASS", output.getvalue())

    def test_filter_test_uses_capture_metadata(self):
        try:
            import numpy as np
        except ImportError:
            self.skipTest("numpy is not installed")
        config = FilterModelConfig(
            ntaps=4,
            n2taps=3,
            fir_coefs=[0x2000, 0x1000, 0, 0] + ZERO_FIR[4:],
            iir_coefs=[0x1000, 0, 0] + ZERO_IIR[3:],
            decimation=2,
        )
        capture = make_mock_capture(
            config,
            MockLoopConfig(samples=1000, noise_amplitude=4000),
        )
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "capture.npz"
            np.savez(
                path,
                adc=np.array(capture.adc_channels, dtype=np.int16).T,
                ntaps=config.ntaps,
                n2taps=config.n2taps,
                decimation=config.decimation,
                fir_coefs=np.array(config.fir_coefs, dtype=np.uint16),
                iir_coefs=np.array(config.iir_coefs, dtype=np.uint16),
            )
            output = io.StringIO()
            with contextlib.redirect_stdout(output):
                code = main(
                    ["filter-test", "--capture", str(path), "--channels", "2"]
                )
            self.assertEqual(code, 0, output.getvalue())
            self.assertIn("ntaps=4", output.getvalue())
            self.assertIn("IIR filter model test: PASS", output.getvalue())

    def test_filter_test_capture(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "capture.csv"
            path.write_text(
                "adc0,adc1\n"
                + "\n".join(f"{index % 100},{index % 50}" for index in range(500))
                + "\n",
                encoding="utf-8",
            )
            output = io.StringIO()
            with contextlib.redirect_stdout(output):
                code = main(
                    [
                        "filter-test",
                        "--capture",
                        str(path),
                        "--ntaps",
                        "0",
                        "--n2taps",
                        "0",
                        "--decimation",
                        "1",
                    ]
                )
            self.assertIn("IIR filter model test:", output.getvalue())
            self.assertIn(code, (0, 1))


if __name__ == "__main__":
    unittest.main()
