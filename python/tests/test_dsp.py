import unittest

from e440.dsp import (
    DAC_AMP_ADDR,
    DECIM_ADDR,
    FIR_TAPS,
    NTAPS_ADDR,
    FilterConfig,
    decimation_word,
    float_to_q15,
    pm_pack,
    pm_unpack,
    q15_to_float,
    to_signed16,
)


class PackingTests(unittest.TestCase):
    def test_pm_roundtrip(self):
        for value in (0x000000, 0x000001, 0x00FFFF, 0x008000, 0xFFEC, 0xFFFFFF):
            raw = pm_pack(value)
            self.assertEqual(raw & 0x000000FF, 0)
            self.assertEqual(pm_unpack(raw), value)

    def test_pm_left_alignment(self):
        self.assertEqual(pm_pack(0xFFFF), 0x00FFFF00)
        self.assertEqual(pm_unpack(0x00FFFF00), 0xFFFF)

    def test_q15(self):
        self.assertEqual(float_to_q15(0.0), 0x0000)
        self.assertEqual(float_to_q15(0.5), 0x4000)
        self.assertEqual(float_to_q15(-0.5), 0xC000)
        self.assertEqual(float_to_q15(1.0), 0x7FFF)
        self.assertAlmostEqual(q15_to_float(0x4000), 0.5)
        self.assertAlmostEqual(q15_to_float(0xC000), -0.5)
        self.assertAlmostEqual(q15_to_float(0x8000), -1.0)

    def test_signed16(self):
        self.assertEqual(to_signed16(0xFFFF), -1)
        self.assertEqual(to_signed16(0x8000), -32768)
        self.assertEqual(to_signed16(0x7FFF), 32767)


class DecimationTests(unittest.TestCase):
    def test_two_channels(self):
        self.assertEqual(decimation_word(10, channels=2), 0xFFEC)

    def test_one_channel(self):
        self.assertEqual(decimation_word(2, channels=1), 0xFFFE)

    def test_legacy_word(self):
        # main_ir.m used 0x10000 - 10 directly.
        cfg = FilterConfig(decimation=None, channels=2, decim_word=0x10000 - 10)
        self.assertEqual(cfg.decim_word, 0xFFF6)

    def test_invalid(self):
        with self.assertRaises(ValueError):
            decimation_word(0)
        with self.assertRaises(ValueError):
            decimation_word(40000, channels=2)


class FilterConfigTests(unittest.TestCase):
    def test_defaults(self):
        cfg = FilterConfig()
        self.assertEqual(len(cfg.fir_coef1), FIR_TAPS)
        self.assertEqual(cfg.decim_word, decimation_word(10, 2))
        words = cfg.scalar_words()
        self.assertEqual(words[NTAPS_ADDR], 32)
        self.assertEqual(words[DECIM_ADDR], 0xFFEC)
        self.assertEqual(words[DAC_AMP_ADDR], 0xFFFF)

    def test_from_floats(self):
        cfg = FilterConfig.from_floats([0.5, -0.5], [0.25])
        self.assertEqual(cfg.fir_coef1[:2], [0x4000, 0xC000])
        self.assertEqual(cfg.iir_coefs[0], 0x2000)
        self.assertEqual(len(cfg.iir_coefs), 8)

    def test_requires_decimation(self):
        with self.assertRaises(ValueError):
            FilterConfig(decimation=None, decim_word=None)


if __name__ == "__main__":
    unittest.main()
