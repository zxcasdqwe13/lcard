import unittest
from pathlib import Path

from e440 import E440, FilterConfig
from e440.backend.mock import MockBackend
from e440.dsp import (
    DECIM_ADDR,
    FIR_COEF1_ADDR,
    IIR_B_COEF_ADDR,
    N2TAPS_ADDR,
    NTAPS_ADDR,
    PROC_SWITCH_ADDR,
    SHIFT_ADDR,
)
from e440.exceptions import E440Closed

REPO_ROOT = Path(__file__).resolve().parents[2]
BIOS = REPO_ROOT / "ADI_DSP" / "E440.BIO"


class MockDeviceTests(unittest.TestCase):
    def setUp(self):
        self.backend = MockBackend()
        self.device = E440.open(backend=self.backend)

    def tearDown(self):
        self.device.close()

    def test_open_and_description(self):
        self.assertTrue(self.backend.opened)
        description = self.device.description
        self.assertEqual(description.company_name, "L-Card")
        self.assertEqual(description.device_name, "E14-440")
        self.assertIn("E14-440", description.summary())

    def test_load_bios(self):
        self.device.load_bios(str(BIOS))
        self.assertEqual(self.backend.bios_path, str(BIOS))

    def test_load_missing_bios(self):
        with self.assertRaises(Exception):
            self.device.load_bios(str(BIOS) + ".missing")

    def test_adc_configuration(self):
        actual = self.device.configure_adc(
            rate=100.0,
            channels=2,
            inter_kadr_delay=0.001,
            control_table=(128, 131),
        )
        self.assertEqual(actual.adc_rate, 100.0)
        self.assertEqual(actual.channels, 2)
        self.assertEqual(actual.inter_kadr_delay, 0.001)
        self.assertEqual(actual.control_table[:2], [128, 131])
        self.assertEqual(len(actual.control_table), 128)

    def test_apply_filters(self):
        config = FilterConfig(
            ntaps=32,
            fir_coef1=[0x8000] + [0] * 63,
            decimation=10,
            channels=2,
        )
        self.device.apply_filters(config)

        self.assertEqual(self.device.read_pm_word(NTAPS_ADDR), 32)
        self.assertEqual(self.device.read_pm_word(N2TAPS_ADDR), 8)
        self.assertEqual(self.device.read_pm_word(SHIFT_ADDR), 0xFFFF)
        self.assertEqual(self.device.read_pm_word(PROC_SWITCH_ADDR), 1)
        self.assertEqual(self.device.read_pm_word(DECIM_ADDR), 0xFFEC)
        self.assertEqual(self.device.read_pm_word(FIR_COEF1_ADDR), 0x8000)
        self.assertEqual(self.device.read_pm_word(FIR_COEF1_ADDR + 63), 0)
        self.assertEqual(self.device.read_pm_word(IIR_B_COEF_ADDR), 0)

        # The backend stores left-aligned 32-bit PM words.
        self.assertEqual(self.backend.pm[NTAPS_ADDR], 32 << 8)
        self.assertEqual(self.backend.pm[DECIM_ADDR], 0xFFEC << 8)

    def test_acquire_blocks(self):
        self.device.configure_adc(rate=200.0, channels=2)
        blocks = list(self.device.acquire_blocks(3, buffer_words=1024))
        self.assertEqual(len(blocks), 3)
        self.assertEqual([len(block) for block in blocks], [1024] * 3)
        samples = self.device.acquire_all(2, buffer_words=512)
        self.assertEqual(len(samples), 1024)
        even = samples[0::2]
        odd = samples[1::2]
        self.assertGreater(max(even) - min(even), 1000)
        self.assertGreater(max(odd) - min(odd), 1000)
        self.assertNotEqual(list(even[:16]), list(odd[:16]))
        self.assertFalse(self.backend.adc_running)

    def test_dm_and_dac_history(self):
        self.device.write_dm_word(0x3FD0, 123)
        self.assertEqual(self.device.read_dm_word(0x3FD0), 123)
        history = self.device.read_dac_history(8)
        self.assertEqual(len(history), 8)
        self.assertEqual(history[0], 123)

    def test_close_is_idempotent(self):
        self.device.close()
        self.device.close()
        self.assertTrue(self.backend.released)
        with self.assertRaises(E440Closed):
            self.device.get_adc_params()

    def test_open_finds_no_device(self):
        backend = MockBackend()
        with self.assertRaises(Exception):
            E440.open(slots=(1, 2), backend=backend)
        self.assertTrue(backend.released)


if __name__ == "__main__":
    unittest.main()
