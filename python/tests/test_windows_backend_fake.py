"""Exercise the Windows vtable plumbing on Linux with a fake C++ object.

This does not replace a hardware test, but it verifies that vtable indices,
packed structures and the PM left-alignment logic are wired correctly without
needing Windows.
"""

import ctypes
import unittest
from pathlib import Path
from unittest import mock

from e440 import structs as s
from e440.backend import windows


class FakeDevice:
    def __init__(self):
        self.pm = {}
        self.released = False


class WindowsBackendFakeTests(unittest.TestCase):
    def setUp(self):
        self.device = FakeDevice()
        self.callbacks = []
        self.vtable = (ctypes.c_void_p * 46)()
        self._install(0, self._open, ctypes.c_int32, ctypes.c_uint16)
        self._install(2, self._release, ctypes.c_int32)
        self._install(7, self._last_error, ctypes.c_int32,
                      ctypes.POINTER(s.LAST_ERROR_INFO_LUSBAPI))
        self._install(12, self._get_adc, ctypes.c_int32,
                      ctypes.POINTER(s.ADC_PARS_E440))
        self._install(31, self._get_description, ctypes.c_int32,
                      ctypes.POINTER(s.MODULE_DESCRIPTION_E440))
        self._install(37, self._put_pm, ctypes.c_int32,
                      ctypes.c_uint16, ctypes.c_uint32)
        self._install(38, self._get_pm, ctypes.c_int32,
                      ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint32))

        self.object = (ctypes.c_void_p * 1)(ctypes.addressof(self.vtable))
        self.fake_dll = mock.MagicMock()
        self.fake_dll.CreateLInstance.return_value = ctypes.addressof(self.object)

        self.patches = [
            mock.patch.object(windows, "_windows_only", lambda: None),
            mock.patch.object(
                windows,
                "_load_dll",
                lambda path=None: (self.fake_dll, Path("fake/Lusbapi64.dll")),
            ),
            mock.patch.object(ctypes, "WinDLL", create=True, return_value=mock.MagicMock()),
            mock.patch.object(ctypes, "WINFUNCTYPE", ctypes.CFUNCTYPE, create=True),
        ]
        for patch in self.patches:
            patch.start()
        self.backend = windows.WindowsBackend()
        self.assertTrue(self.backend.open(0))

    def tearDown(self):
        for patch in reversed(self.patches):
            patch.stop()

    def _install(self, index, function, restype, *argtypes):
        callback = ctypes.CFUNCTYPE(restype, ctypes.c_void_p, *argtypes)(function)
        self.callbacks.append(callback)
        self.vtable[index] = ctypes.cast(callback, ctypes.c_void_p).value

    def _open(self, this, slot):
        return 1

    def _release(self, this):
        self.device.released = True
        return 1

    def _last_error(self, this, info):
        info.contents.ErrorNumber = 100
        info.contents.ErrorString[0] = ord("O")
        info.contents.ErrorString[1] = ord("K")
        return 1

    def _get_adc(self, this, params):
        raw = params.contents
        raw.ChannelsQuantity = 2
        raw.AdcRate = 123.0
        raw.InterKadrDelay = 0.002
        raw.ControlTable[0] = 128
        raw.ControlTable[1] = 131
        return 1

    def _get_description(self, this, description):
        raw = description.contents
        for index, byte in enumerate(b"L-Card"):
            raw.Module.CompanyName[index] = byte
        for index, byte in enumerate(b"E14-440"):
            raw.Module.DeviceName[index] = byte
        raw.Dsp.ClockRate = 24.0e6
        return 1

    def _put_pm(self, this, address, value):
        self.device.pm[int(address)] = int(value)
        return 1

    def _get_pm(self, this, address, out):
        out[0] = self.device.pm.get(int(address), 0)
        return 1

    def test_vtable_calls_and_conversions(self):
        params = self.backend.get_adc_params()
        self.assertEqual(params.channels, 2)
        self.assertEqual(params.adc_rate, 123.0)
        self.assertEqual(params.control_table[:2], [128, 131])

        description = self.backend.get_module_description()
        self.assertEqual(description.company_name, "L-Card")
        self.assertEqual(description.device_name, "E14-440")

        message, number = self.backend.get_last_error()
        self.assertEqual(number, 100)
        self.assertEqual(message, "OK")

        self.assertTrue(self.backend.put_pm_word(0x7B, 32 << 8))
        self.assertEqual(self.backend.get_pm_word(0x7B), 32 << 8)
        self.assertEqual(self.device.pm[0x7B], 32 << 8)

    def test_release_clears_pointer(self):
        self.backend.release()
        self.assertTrue(self.device.released)
        with self.assertRaises(windows.BackendUnavailable):
            self.backend.get_pm_word(0x7B)


if __name__ == "__main__":
    unittest.main()
