"""Verify ILE440 vtable indices against the L-Card SDK header (when present)."""

import re
import unittest
from pathlib import Path

from e440.backend import windows

HEADER = Path(__file__).resolve().parents[2] / "stuffs/DLL/Include/Lusbapi.h"

EXPECTED_METHODS = [
    "OpenLDevice",
    "CloseLDevice",
    "ReleaseLInstance",
    "GetModuleHandle",
    "GetModuleName",
    "GetUsbSpeed",
    "LowPowerMode",
    "GetLastErrorInfo",
    "RESET_MODULE",
    "LOAD_MODULE",
    "TEST_MODULE",
    "SEND_COMMAND",
    "GET_ADC_PARS",
    "SET_ADC_PARS",
    "START_ADC",
    "STOP_ADC",
    "ADC_KADR",
    "ADC_SAMPLE",
    "ReadData",
    "GET_DAC_PARS",
    "SET_DAC_PARS",
    "START_DAC",
    "STOP_DAC",
    "WriteData",
    "DAC_SAMPLE",
    "ENABLE_TTL_OUT",
    "TTL_IN",
    "TTL_OUT",
    "ENABLE_FLASH_WRITE",
    "READ_FLASH_WORD",
    "WRITE_FLASH_WORD",
    "GET_MODULE_DESCRIPTION",
    "SAVE_MODULE_DESCRIPTION",
    "PUT_LBIOS_WORD",
    "GET_LBIOS_WORD",
    "PUT_DM_WORD",
    "GET_DM_WORD",
    "PUT_PM_WORD",
    "GET_PM_WORD",
    "PUT_DM_ARRAY",
    "GET_DM_ARRAY",
    "PUT_PM_ARRAY",
    "GET_PM_ARRAY",
    "ERASE_BOOT_FLASH",
    "PUT_ARRAY_BOOT_FLASH",
    "GET_ARRAY_BOOT_FLASH",
]

EXPECTED_CONSTANTS = [
    "V_OPEN_DEVICE",
    "V_CLOSE_DEVICE",
    "V_RELEASE_INSTANCE",
    "V_GET_MODULE_HANDLE",
    "V_GET_MODULE_NAME",
    "V_GET_USB_SPEED",
    "V_LOW_POWER_MODE",
    "V_GET_LAST_ERROR_INFO",
    "V_RESET_MODULE",
    "V_LOAD_MODULE",
    "V_TEST_MODULE",
    "V_SEND_COMMAND",
    "V_GET_ADC_PARS",
    "V_SET_ADC_PARS",
    "V_START_ADC",
    "V_STOP_ADC",
    "V_ADC_KADR",
    "V_ADC_SAMPLE",
    "V_READ_DATA",
    "V_GET_DAC_PARS",
    "V_SET_DAC_PARS",
    "V_START_DAC",
    "V_STOP_DAC",
    "V_WRITE_DATA",
    "V_DAC_SAMPLE",
    "V_ENABLE_TTL_OUT",
    "V_TTL_IN",
    "V_TTL_OUT",
    "V_ENABLE_FLASH_WRITE",
    "V_READ_FLASH_WORD",
    "V_WRITE_FLASH_WORD",
    "V_GET_MODULE_DESCRIPTION",
    "V_SAVE_MODULE_DESCRIPTION",
    "V_PUT_LBIOS_WORD",
    "V_GET_LBIOS_WORD",
    "V_PUT_DM_WORD",
    "V_GET_DM_WORD",
    "V_PUT_PM_WORD",
    "V_GET_PM_WORD",
    "V_PUT_DM_ARRAY",
    "V_GET_DM_ARRAY",
    "V_PUT_PM_ARRAY",
    "V_GET_PM_ARRAY",
    "V_ERASE_BOOT_FLASH",
    "V_PUT_ARRAY_BOOT_FLASH",
    "V_GET_ARRAY_BOOT_FLASH",
]


def _virtual_methods(text: str, marker: str) -> list[str]:
    start = text.index(marker)
    end = text.index("};", start)
    body = text[start:end]
    return re.findall(r"virtual\s+\w+\s+WINAPI\s+(\w+)\s*\(", body)


class VtableOrderTests(unittest.TestCase):
    def test_constant_values(self):
        self.assertEqual(
            [getattr(windows, name) for name in EXPECTED_CONSTANTS],
            list(range(len(EXPECTED_CONSTANTS))),
        )

    @unittest.skipUnless(HEADER.is_file(), "stuffs/DLL SDK headers are not present")
    def test_matches_sdk_header(self):
        text = HEADER.read_text(encoding="latin-1")
        base = _virtual_methods(text, "struct ILUSBBASE")
        device = _virtual_methods(text, "struct ILE440 : public ILUSBBASE")
        self.assertEqual(base + device, EXPECTED_METHODS)


if __name__ == "__main__":
    unittest.main()
