"""ctypes mirrors of the LCard SDK structures used by the E14-440.

All structures use ``#pragma pack(1)``, matching ``LusbapiTypes.h`` and
``Lusbapi.h``.  Sizes are asserted in ``python/tests/test_structs.py`` so ABI
mistakes are caught on any platform.
"""

from __future__ import annotations

import ctypes
from ctypes import wintypes

BYTE = ctypes.c_uint8
WORD = ctypes.c_uint16
DWORD = ctypes.c_uint32
BOOL = ctypes.c_int32
SHORT = ctypes.c_int16
ULONG_PTR = ctypes.c_size_t
HANDLE = ctypes.c_void_p

PM_WORDS = 64
MAX_CONTROL_TABLE_LENGTH_E440 = 128
ADC_INPUT_RANGES_QUANTITY_E440 = 4
DAC_CHANNELS_QUANTITY_E440 = 2

# Calibration array sizes from LusbapiTypes.h (not the E440 input-range count).
ADC_CALIBR_COEFS_QUANTITY_LUSBAPI = 128
DAC_CALIBR_COEFS_QUANTITY_LUSBAPI = 128

NAME_LINE_LENGTH = 25
SERIAL_NUMBER_STRING_LENGTH = 16
COMMENT_LINE_LENGTH = 256


class OVERLAPPED(ctypes.Structure):
    """Win32 ``OVERLAPPED`` without relying on ``ctypes.wintypes.OVERLAPPED``."""

    _fields_ = [
        ("Internal", ULONG_PTR),
        ("InternalHigh", ULONG_PTR),
        ("Offset", DWORD),
        ("OffsetHigh", DWORD),
        ("hEvent", HANDLE),
    ]


class IO_REQUEST_LUSBAPI(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Buffer", ctypes.POINTER(SHORT)),
        ("NumberOfWordsToPass", DWORD),
        ("NumberOfWordsPassed", DWORD),
        ("Overlapped", ctypes.POINTER(OVERLAPPED)),
        ("TimeOut", DWORD),
    ]


class LAST_ERROR_INFO_LUSBAPI(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("ErrorString", BYTE * 256),
        ("ErrorNumber", DWORD),
    ]


class VERSION_INFO_LUSBAPI(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Version", BYTE * 10),
        ("Date", BYTE * 14),
        ("Manufacturer", BYTE * NAME_LINE_LENGTH),
        ("Author", BYTE * NAME_LINE_LENGTH),
        ("Comment", BYTE * COMMENT_LINE_LENGTH),
    ]


class MCU_VERSION_INFO_LUSBAPI(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("FwVersion", VERSION_INFO_LUSBAPI),
        ("BlVersion", VERSION_INFO_LUSBAPI),
    ]


class MODULE_INFO_LUSBAPI(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("CompanyName", BYTE * NAME_LINE_LENGTH),
        ("DeviceName", BYTE * NAME_LINE_LENGTH),
        ("SerialNumber", BYTE * SERIAL_NUMBER_STRING_LENGTH),
        ("Revision", BYTE),
        ("Modification", BYTE),
        ("Comment", BYTE * COMMENT_LINE_LENGTH),
    ]


class DSP_INFO_LUSBAPI(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Active", BOOL),
        ("Name", BYTE * NAME_LINE_LENGTH),
        ("ClockRate", ctypes.c_double),
        ("Version", VERSION_INFO_LUSBAPI),
        ("Comment", BYTE * COMMENT_LINE_LENGTH),
    ]


class MCU_INFO_LUSBAPI(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Active", BOOL),
        ("Name", BYTE * NAME_LINE_LENGTH),
        ("ClockRate", ctypes.c_double),
        ("Version", MCU_VERSION_INFO_LUSBAPI),
        ("Comment", BYTE * COMMENT_LINE_LENGTH),
    ]


class ADC_INFO_LUSBAPI(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Active", BOOL),
        ("Name", BYTE * NAME_LINE_LENGTH),
        ("OffsetCalibration", ctypes.c_double * ADC_CALIBR_COEFS_QUANTITY_LUSBAPI),
        ("ScaleCalibration", ctypes.c_double * ADC_CALIBR_COEFS_QUANTITY_LUSBAPI),
        ("Comment", BYTE * COMMENT_LINE_LENGTH),
    ]


class DAC_INFO_LUSBAPI(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Active", BOOL),
        ("Name", BYTE * NAME_LINE_LENGTH),
        ("OffsetCalibration", ctypes.c_double * DAC_CALIBR_COEFS_QUANTITY_LUSBAPI),
        ("ScaleCalibration", ctypes.c_double * DAC_CALIBR_COEFS_QUANTITY_LUSBAPI),
        ("Comment", BYTE * COMMENT_LINE_LENGTH),
    ]


class DIGITAL_IO_INFO_LUSBAPI(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Active", BOOL),
        ("Name", BYTE * NAME_LINE_LENGTH),
        ("InLinesQuantity", WORD),
        ("OutLinesQuantity", WORD),
        ("Comment", BYTE * COMMENT_LINE_LENGTH),
    ]


class INTERFACE_INFO_LUSBAPI(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Active", BOOL),
        ("Name", BYTE * NAME_LINE_LENGTH),
        ("Comment", BYTE * COMMENT_LINE_LENGTH),
    ]


class MODULE_DESCRIPTION_E440(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("Module", MODULE_INFO_LUSBAPI),
        ("Interface", INTERFACE_INFO_LUSBAPI),
        ("Mcu", MCU_INFO_LUSBAPI),
        ("Dsp", DSP_INFO_LUSBAPI),
        ("Adc", ADC_INFO_LUSBAPI),
        ("Dac", DAC_INFO_LUSBAPI),
        ("DigitalIo", DIGITAL_IO_INFO_LUSBAPI),
    ]


class ADC_PARS_E440(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("IsAdcEnabled", BOOL),
        ("IsCorrectionEnabled", BOOL),
        ("AdcClockSource", WORD),
        ("InputMode", WORD),
        ("SynchroAdType", WORD),
        ("SynchroAdMode", WORD),
        ("SynchroAdChannel", WORD),
        ("SynchroAdPorog", SHORT),
        ("ChannelsQuantity", WORD),
        ("ControlTable", WORD * MAX_CONTROL_TABLE_LENGTH_E440),
        ("AdcRate", ctypes.c_double),
        ("InterKadrDelay", ctypes.c_double),
        ("KadrRate", ctypes.c_double),
        ("AdcFifoBaseAddress", WORD),
        ("AdcFifoLength", WORD),
        (
            "AdcOffsetCoefs",
            ctypes.c_double * ADC_INPUT_RANGES_QUANTITY_E440,
        ),
        ("AdcScaleCoefs", ctypes.c_double * ADC_INPUT_RANGES_QUANTITY_E440),
    ]


class DAC_PARS_E440(ctypes.Structure):
    _pack_ = 1
    _fields_ = [
        ("DacEnabled", BOOL),
        ("DacRate", ctypes.c_double),
        ("DacFifoBaseAddress", WORD),
        ("DacFifoLength", WORD),
    ]


# Expected sizes of packed structures on 64-bit Windows.  Used by tests.
EXPECTED_SIZES = {
    IO_REQUEST_LUSBAPI: 28,
    LAST_ERROR_INFO_LUSBAPI: 260,
    VERSION_INFO_LUSBAPI: 330,
    MCU_VERSION_INFO_LUSBAPI: 660,
    MODULE_INFO_LUSBAPI: 324,
    DSP_INFO_LUSBAPI: 623,
    MCU_INFO_LUSBAPI: 953,
    ADC_INFO_LUSBAPI: 2333,
    DAC_INFO_LUSBAPI: 2333,
    DIGITAL_IO_INFO_LUSBAPI: 289,
    INTERFACE_INFO_LUSBAPI: 285,
    MODULE_DESCRIPTION_E440: 7140,
    ADC_PARS_E440: 370,
    DAC_PARS_E440: 16,
}


__all__ = [name for name in dir() if name.endswith(("_LUSBAPI", "_E440"))]
