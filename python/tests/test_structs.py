import ctypes
import unittest

from e440 import structs as s


class StructureSizeTests(unittest.TestCase):
    def test_expected_sizes(self):
        for cls, expected in s.EXPECTED_SIZES.items():
            with self.subTest(cls=cls.__name__):
                self.assertEqual(ctypes.sizeof(cls), expected)

    def test_overlapped(self):
        self.assertEqual(ctypes.sizeof(s.OVERLAPPED), 32)

    def test_io_request_layout(self):
        self.assertEqual(s.IO_REQUEST_LUSBAPI.Buffer.offset, 0)
        self.assertEqual(s.IO_REQUEST_LUSBAPI.NumberOfWordsToPass.offset, 8)
        self.assertEqual(s.IO_REQUEST_LUSBAPI.NumberOfWordsPassed.offset, 12)
        self.assertEqual(s.IO_REQUEST_LUSBAPI.Overlapped.offset, 16)
        self.assertEqual(s.IO_REQUEST_LUSBAPI.TimeOut.offset, 24)

    def test_adc_params_layout(self):
        self.assertEqual(s.ADC_PARS_E440.ControlTable.offset, 22)
        self.assertEqual(s.ADC_PARS_E440.AdcRate.offset, 278)
        self.assertEqual(s.ADC_PARS_E440.InterKadrDelay.offset, 286)
        self.assertEqual(s.ADC_PARS_E440.KadrRate.offset, 294)
        self.assertEqual(s.ADC_PARS_E440.AdcOffsetCoefs.offset, 306)
        self.assertEqual(s.ADC_PARS_E440.AdcScaleCoefs.offset, 338)

    def test_module_description_layout(self):
        self.assertEqual(s.MODULE_DESCRIPTION_E440.Module.offset, 0)
        self.assertEqual(s.MODULE_DESCRIPTION_E440.Interface.offset, 324)
        self.assertEqual(s.MODULE_DESCRIPTION_E440.Mcu.offset, 609)
        self.assertEqual(s.MODULE_DESCRIPTION_E440.Dsp.offset, 1562)
        self.assertEqual(s.MODULE_DESCRIPTION_E440.Adc.offset, 2185)
        self.assertEqual(s.MODULE_DESCRIPTION_E440.Dac.offset, 4518)
        self.assertEqual(s.MODULE_DESCRIPTION_E440.DigitalIo.offset, 6851)


if __name__ == "__main__":
    unittest.main()
