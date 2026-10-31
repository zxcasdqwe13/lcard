"""Windows backend: LCard ``Lusbapi64.dll`` via ctypes and the ILE440 vtable.

``Lusbapi64.dll`` exports only ``CreateLInstance`` and ``GetDllVersion``.
``CreateLInstance("e440")`` returns an ``ILE440*``; the rest of the API is a
C++ vtable whose order is defined in ``stuffs/DLL/Include/Lusbapi.h``.  The
vtable is called directly, so no compiler or MATLAB interface DLL is needed.

The module is importable on any platform; instantiating the backend on a
non-Windows system raises :class:`BackendUnavailable`.
"""

from __future__ import annotations

import array
import ctypes
import os
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from ..dsp import to_signed16
from ..model import AdcParams, DacParams, ModuleDescription
from ..structs import (
    ADC_PARS_E440,
    DAC_PARS_E440,
    IO_REQUEST_LUSBAPI,
    LAST_ERROR_INFO_LUSBAPI,
    MODULE_DESCRIPTION_E440,
    OVERLAPPED,
    SHORT,
    WORD,
)
from .base import Backend, BackendUnavailable, WAIT_TIMEOUT

BOOL = ctypes.c_int32
DWORD = ctypes.c_uint32
UINT32 = ctypes.c_uint32

# ILE440 vtable indices: 8 methods from ILUSBBASE, then ILE440 in declaration
# order (Lusbapi.h).  Keep in sync with the header.
V_OPEN_DEVICE = 0
V_CLOSE_DEVICE = 1
V_RELEASE_INSTANCE = 2
V_GET_MODULE_HANDLE = 3
V_GET_MODULE_NAME = 4
V_GET_USB_SPEED = 5
V_LOW_POWER_MODE = 6
V_GET_LAST_ERROR_INFO = 7
V_RESET_MODULE = 8
V_LOAD_MODULE = 9
V_TEST_MODULE = 10
V_SEND_COMMAND = 11
V_GET_ADC_PARS = 12
V_SET_ADC_PARS = 13
V_START_ADC = 14
V_STOP_ADC = 15
V_ADC_KADR = 16
V_ADC_SAMPLE = 17
V_READ_DATA = 18
V_GET_DAC_PARS = 19
V_SET_DAC_PARS = 20
V_START_DAC = 21
V_STOP_DAC = 22
V_WRITE_DATA = 23
V_DAC_SAMPLE = 24
V_ENABLE_TTL_OUT = 25
V_TTL_IN = 26
V_TTL_OUT = 27
V_ENABLE_FLASH_WRITE = 28
V_READ_FLASH_WORD = 29
V_WRITE_FLASH_WORD = 30
V_GET_MODULE_DESCRIPTION = 31
V_SAVE_MODULE_DESCRIPTION = 32
V_PUT_LBIOS_WORD = 33
V_GET_LBIOS_WORD = 34
V_PUT_DM_WORD = 35
V_GET_DM_WORD = 36
V_PUT_PM_WORD = 37
V_GET_PM_WORD = 38
V_PUT_DM_ARRAY = 39
V_GET_DM_ARRAY = 40
V_PUT_PM_ARRAY = 41
V_GET_PM_ARRAY = 42
V_ERASE_BOOT_FLASH = 43
V_PUT_ARRAY_BOOT_FLASH = 44
V_GET_ARRAY_BOOT_FLASH = 45

ERROR_NO_ERROR = 100


def _windows_only() -> None:
    if sys.platform != "win32":
        raise BackendUnavailable(
            "the LCard backend requires Windows and a 64-bit Python; "
            "use e440.backend.mock.MockBackend for development on this system"
        )
    if ctypes.sizeof(ctypes.c_void_p) != 8:
        raise BackendUnavailable(
            "Lusbapi64.dll is x86-64; use 64-bit Python "
            f"(current pointer size: {ctypes.sizeof(ctypes.c_void_p) * 8} bit)"
        )


def find_lusbapi64() -> Path:
    """Locate ``Lusbapi64.dll`` using env var, repo layout, then system path."""
    env = os.environ.get("E440_LUSBAPI64")
    if env:
        path = Path(env).expanduser()
        if path.is_file():
            return path
        raise FileNotFoundError(f"E440_LUSBAPI64={env!r} does not exist")

    repo_root = Path(__file__).resolve().parents[4]
    candidates = [
        repo_root / "MyCppLib" / "Lusbapi64.dll",
        repo_root / "xzMyCppLib" / "Lusbapi64.dll",
        repo_root / "stuffs" / "DLL" / "Bin" / "Lusbapi64.dll",
    ]
    for candidate in candidates:
        if candidate.is_file():
            return candidate

    # Fall back to the normal Windows DLL search order.
    return Path("Lusbapi64.dll")


def _decode(value: Any, encoding: str = "cp1251") -> str:
    raw = bytes(value)
    raw = raw.split(b"\0", 1)[0]
    for candidate in (encoding, "utf-8"):
        try:
            return raw.decode(candidate)
        except UnicodeDecodeError:
            continue
    return raw.decode("cp1251", errors="replace")


def _path_bytes(path: str | os.PathLike[str]) -> bytes:
    text = os.fspath(path)
    try:
        return text.encode("mbcs")
    except (LookupError, UnicodeEncodeError):
        return os.fsencode(text)


@dataclass
class WinIoRequest:
    """Resources backing one asynchronous ``ReadData`` request."""

    struct: IO_REQUEST_LUSBAPI
    buffer: Any
    overlapped: OVERLAPPED
    event: int | None
    capacity: int
    transferred: int | None = None


class WindowsBackend(Backend):
    name = "windows"

    def __init__(self, dll_path: str | os.PathLike[str] | None = None) -> None:
        _windows_only()
        self._dll, self.dll_path = _load_dll(dll_path)
        self._ptr: int | None = None
        self._device_handle: int | None = None
        self._methods: dict[tuple[int, Any, tuple[Any, ...]], Any] = {}
        self._kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
        self._configure_kernel32()

    # -- low level ---------------------------------------------------------

    def _configure_kernel32(self) -> None:
        k32 = self._kernel32
        k32.CreateEventW.argtypes = [
            ctypes.c_void_p,
            ctypes.c_int,
            ctypes.c_int,
            ctypes.c_wchar_p,
        ]
        k32.CreateEventW.restype = ctypes.c_void_p
        k32.WaitForSingleObject.argtypes = [ctypes.c_void_p, DWORD]
        k32.WaitForSingleObject.restype = DWORD
        k32.CloseHandle.argtypes = [ctypes.c_void_p]
        k32.CloseHandle.restype = ctypes.c_int
        k32.GetOverlappedResult.argtypes = [
            ctypes.c_void_p,
            ctypes.POINTER(OVERLAPPED),
            ctypes.POINTER(DWORD),
            ctypes.c_int,
        ]
        k32.GetOverlappedResult.restype = ctypes.c_int

    def _method(self, index: int, restype: Any, *argtypes: Any) -> Any:
        key = (index, restype, argtypes)
        cached = self._methods.get(key)
        if cached is not None:
            return cached
        if self._ptr is None:
            raise BackendUnavailable("device interface is not created")
        vtable = ctypes.cast(
            self._ptr, ctypes.POINTER(ctypes.POINTER(ctypes.c_void_p))
        ).contents
        prototype = ctypes.WINFUNCTYPE(
            restype, ctypes.c_void_p, *argtypes
        )  # type: ignore[attr-defined]
        function = prototype(vtable[index])
        self._methods[key] = function
        return function

    def _call(
        self, index: int, restype: Any, *argtypes: Any, args: tuple[Any, ...] = ()
    ) -> Any:
        function = self._method(index, restype, *argtypes)
        return function(self._ptr, *args)

    def _get_device_handle(self) -> int:
        if self._device_handle is None:
            handle = self._call(V_GET_MODULE_HANDLE, ctypes.c_void_p)
            self._device_handle = int(handle or 0)
        return self._device_handle

    def _create_instance(self) -> int:
        if self._ptr is not None:
            return self._ptr
        create = self._dll.CreateLInstance
        create.argtypes = [ctypes.c_char_p]
        create.restype = ctypes.c_void_p
        ptr = create(b"e440")
        if not ptr:
            raise BackendUnavailable(
                "CreateLInstance('e440') returned NULL; "
                "install the L-Card driver and check the DLL bitness"
            )
        self._ptr = int(ptr)
        self._methods.clear()
        return self._ptr

    # -- lifecycle ---------------------------------------------------------

    def open(self, slot: int) -> bool:
        self._create_instance()
        return bool(
            self._call(V_OPEN_DEVICE, BOOL, WORD, args=(int(slot) & 0xFFFF,))
        )

    def release(self) -> None:
        if self._ptr is None:
            return
        try:
            self._call(V_RELEASE_INSTANCE, BOOL)
        finally:
            # ReleaseLInstance() closes the device and deletes the object.
            self._ptr = None
            self._device_handle = None
            self._methods.clear()

    def get_last_error(self) -> tuple[str, int]:
        if self._ptr is None:
            return ("device interface is not created", 0)
        info = LAST_ERROR_INFO_LUSBAPI()
        ok = self._call(
            V_GET_LAST_ERROR_INFO, BOOL, ctypes.POINTER(LAST_ERROR_INFO_LUSBAPI),
            args=(ctypes.byref(info),),
        )
        if not ok:
            return ("GetLastErrorInfo failed", 0)
        message = _decode(info.ErrorString, "utf-8")
        return (message, int(info.ErrorNumber))

    def load_bios(self, path: str | None) -> bool:
        payload = None if path is None else _path_bytes(path)
        return bool(
            self._call(V_LOAD_MODULE, BOOL, ctypes.c_char_p, args=(payload,))
        )

    def test_module(self) -> bool:
        return bool(self._call(V_TEST_MODULE, BOOL))

    def send_command(self, command: int) -> bool:
        return bool(self._call(V_SEND_COMMAND, BOOL, WORD, args=(command & 0xFFFF,)))

    # -- descriptions ------------------------------------------------------

    def get_module_description(self) -> ModuleDescription:
        raw = MODULE_DESCRIPTION_E440()
        ok = self._call(
            V_GET_MODULE_DESCRIPTION,
            BOOL,
            ctypes.POINTER(MODULE_DESCRIPTION_E440),
            args=(ctypes.byref(raw),),
        )
        if not ok:
            message, number = self.get_last_error()
            raise RuntimeError(f"GET_MODULE_DESCRIPTION failed: {message} ({number})")
        return ModuleDescription(
            company_name=_decode(raw.Module.CompanyName),
            device_name=_decode(raw.Module.DeviceName),
            serial_number=_decode(raw.Module.SerialNumber),
            revision=int(raw.Module.Revision),
            modification=int(raw.Module.Modification),
            comment=_decode(raw.Module.Comment),
            dsp_name=_decode(raw.Dsp.Name),
            dsp_clock_rate=float(raw.Dsp.ClockRate),
            dsp_version=_decode(raw.Dsp.Version.Version, "ascii"),
            mcu_name=_decode(raw.Mcu.Name),
            mcu_version=_decode(raw.Mcu.Version.FwVersion.Version, "ascii"),
            adc_name=_decode(raw.Adc.Name),
            dac_name=_decode(raw.Dac.Name),
            interface_name=_decode(raw.Interface.Name),
            digital_io_name=_decode(raw.DigitalIo.Name),
        )

    # -- ADC / DAC ---------------------------------------------------------

    def get_adc_params(self) -> AdcParams:
        raw = ADC_PARS_E440()
        ok = self._call(
            V_GET_ADC_PARS, BOOL, ctypes.POINTER(ADC_PARS_E440),
            args=(ctypes.byref(raw),),
        )
        if not ok:
            message, number = self.get_last_error()
            raise RuntimeError(f"GET_ADC_PARS failed: {message} ({number})")
        return AdcParams(
            is_adc_enabled=bool(raw.IsAdcEnabled),
            is_correction_enabled=bool(raw.IsCorrectionEnabled),
            adc_clock_source=int(raw.AdcClockSource),
            input_mode=int(raw.InputMode),
            synchro_ad_type=int(raw.SynchroAdType),
            synchro_ad_mode=int(raw.SynchroAdMode),
            synchro_ad_channel=int(raw.SynchroAdChannel),
            synchro_ad_porog=int(raw.SynchroAdPorog),
            channels=int(raw.ChannelsQuantity),
            control_table=[int(value) for value in raw.ControlTable],
            adc_rate=float(raw.AdcRate),
            inter_kadr_delay=float(raw.InterKadrDelay),
            kadr_rate=float(raw.KadrRate),
            adc_fifo_base_address=int(raw.AdcFifoBaseAddress),
            adc_fifo_length=int(raw.AdcFifoLength),
            adc_offset_coefs=[float(value) for value in raw.AdcOffsetCoefs],
            adc_scale_coefs=[float(value) for value in raw.AdcScaleCoefs],
        )

    def set_adc_params(self, params: AdcParams) -> bool:
        raw = ADC_PARS_E440()
        raw.IsAdcEnabled = int(params.is_adc_enabled)
        raw.IsCorrectionEnabled = int(params.is_correction_enabled)
        raw.AdcClockSource = params.adc_clock_source & 0xFFFF
        raw.InputMode = params.input_mode & 0xFFFF
        raw.SynchroAdType = params.synchro_ad_type & 0xFFFF
        raw.SynchroAdMode = params.synchro_ad_mode & 0xFFFF
        raw.SynchroAdChannel = params.synchro_ad_channel & 0xFFFF
        raw.SynchroAdPorog = to_signed16(params.synchro_ad_porog)
        raw.ChannelsQuantity = params.channels & 0xFFFF
        for index, value in enumerate(params.control_table[:128]):
            raw.ControlTable[index] = value & 0xFFFF
        raw.AdcRate = params.adc_rate
        raw.InterKadrDelay = params.inter_kadr_delay
        raw.KadrRate = params.kadr_rate
        raw.AdcFifoBaseAddress = params.adc_fifo_base_address & 0xFFFF
        raw.AdcFifoLength = params.adc_fifo_length & 0xFFFF
        for index, value in enumerate(params.adc_offset_coefs):
            raw.AdcOffsetCoefs[index] = value
        for index, value in enumerate(params.adc_scale_coefs):
            raw.AdcScaleCoefs[index] = value
        return bool(
            self._call(
                V_SET_ADC_PARS,
                BOOL,
                ctypes.POINTER(ADC_PARS_E440),
                args=(ctypes.byref(raw),),
            )
        )

    def start_adc(self) -> bool:
        return bool(self._call(V_START_ADC, BOOL))

    def stop_adc(self) -> bool:
        return bool(self._call(V_STOP_ADC, BOOL))

    def get_dac_params(self) -> DacParams:
        raw = DAC_PARS_E440()
        ok = self._call(
            V_GET_DAC_PARS, BOOL, ctypes.POINTER(DAC_PARS_E440),
            args=(ctypes.byref(raw),),
        )
        if not ok:
            message, number = self.get_last_error()
            raise RuntimeError(f"GET_DAC_PARS failed: {message} ({number})")
        return DacParams(
            dac_enabled=bool(raw.DacEnabled),
            dac_rate=float(raw.DacRate),
            dac_fifo_base_address=int(raw.DacFifoBaseAddress),
            dac_fifo_length=int(raw.DacFifoLength),
        )

    def set_dac_params(self, params: DacParams) -> bool:
        raw = DAC_PARS_E440()
        raw.DacEnabled = int(params.dac_enabled)
        raw.DacRate = params.dac_rate
        raw.DacFifoBaseAddress = params.dac_fifo_base_address & 0xFFFF
        raw.DacFifoLength = params.dac_fifo_length & 0xFFFF
        return bool(
            self._call(
                V_SET_DAC_PARS,
                BOOL,
                ctypes.POINTER(DAC_PARS_E440),
                args=(ctypes.byref(raw),),
            )
        )

    def start_dac(self) -> bool:
        return bool(self._call(V_START_DAC, BOOL))

    def stop_dac(self) -> bool:
        return bool(self._call(V_STOP_DAC, BOOL))

    def dac_sample(self, value: int, channel: int = 0) -> bool:
        sample = SHORT(to_signed16(value))
        return bool(
            self._call(
                V_DAC_SAMPLE,
                BOOL,
                ctypes.POINTER(SHORT),
                WORD,
                args=(ctypes.byref(sample), channel & 0xFFFF),
            )
        )

    def enable_ttl_out(self, enable: bool) -> bool:
        return bool(self._call(V_ENABLE_TTL_OUT, BOOL, BOOL, args=(int(enable),)))

    def ttl_out(self, value: int) -> bool:
        return bool(self._call(V_TTL_OUT, BOOL, WORD, args=(value & 0xFFFF,)))

    def ttl_in(self) -> int | None:
        value = WORD()
        ok = self._call(
            V_TTL_IN, BOOL, ctypes.POINTER(WORD), args=(ctypes.byref(value),)
        )
        return int(value.value) if ok else None

    # -- DSP memory --------------------------------------------------------

    def put_pm_word(self, address: int, raw: int) -> bool:
        return bool(
            self._call(
                V_PUT_PM_WORD,
                BOOL,
                WORD,
                UINT32,
                args=(address & 0xFFFF, raw & 0xFFFFFFFF),
            )
        )

    def get_pm_word(self, address: int) -> int | None:
        raw = UINT32()
        ok = self._call(
            V_GET_PM_WORD,
            BOOL,
            WORD,
            ctypes.POINTER(UINT32),
            args=(address & 0xFFFF, ctypes.byref(raw)),
        )
        return int(raw.value) if ok else None

    def put_pm_array(self, address: int, raw: list[int]) -> bool:
        if not raw:
            return True
        buffer = (UINT32 * len(raw))(*[value & 0xFFFFFFFF for value in raw])
        return bool(
            self._call(
                V_PUT_PM_ARRAY,
                BOOL,
                WORD,
                WORD,
                ctypes.POINTER(UINT32),
                args=(address & 0xFFFF, len(raw), buffer),
            )
        )

    def get_pm_array(self, address: int, count: int) -> list[int] | None:
        if count <= 0:
            return []
        buffer = (UINT32 * count)()
        ok = self._call(
            V_GET_PM_ARRAY,
            BOOL,
            WORD,
            WORD,
            ctypes.POINTER(UINT32),
            args=(address & 0xFFFF, count, buffer),
        )
        return [int(value) for value in buffer] if ok else None

    def put_dm_word(self, address: int, value: int) -> bool:
        return bool(
            self._call(
                V_PUT_DM_WORD,
                BOOL,
                WORD,
                SHORT,
                args=(address & 0xFFFF, to_signed16(value)),
            )
        )

    def get_dm_word(self, address: int) -> int | None:
        value = SHORT()
        ok = self._call(
            V_GET_DM_WORD,
            BOOL,
            WORD,
            ctypes.POINTER(SHORT),
            args=(address & 0xFFFF, ctypes.byref(value)),
        )
        return int(value.value) if ok else None

    def get_dm_array(self, address: int, count: int) -> list[int] | None:
        if count <= 0:
            return []
        buffer = (SHORT * count)()
        ok = self._call(
            V_GET_DM_ARRAY,
            BOOL,
            WORD,
            WORD,
            ctypes.POINTER(SHORT),
            args=(address & 0xFFFF, count, buffer),
        )
        return [int(value) for value in buffer] if ok else None

    # -- asynchronous reads ------------------------------------------------

    def create_request(self, words: int, timeout_ms: int) -> WinIoRequest:
        if words <= 0:
            raise ValueError("words must be positive")
        # ReadData() clamps the count to [32, 1 MiB] and rounds it down to a
        # multiple of 32, so allocate exactly what the driver will use.
        words = max(0x20, min(words, 1024 * 1024))
        words -= words % 0x20
        buffer = (SHORT * words)()
        overlapped = OVERLAPPED()
        event = self._kernel32.CreateEventW(None, False, False, None)
        if not event:
            raise OSError(
                f"CreateEventW failed (GetLastError={ctypes.get_last_error()})"
            )
        overlapped.hEvent = event
        request = WinIoRequest(
            struct=IO_REQUEST_LUSBAPI(),
            buffer=buffer,
            overlapped=overlapped,
            event=int(event),
            capacity=words,
        )
        request.struct.Buffer = ctypes.cast(buffer, ctypes.POINTER(SHORT))
        request.struct.NumberOfWordsToPass = words
        request.struct.NumberOfWordsPassed = 0
        request.struct.Overlapped = ctypes.pointer(request.overlapped)
        request.struct.TimeOut = timeout_ms
        return request

    def free_request(self, request: WinIoRequest) -> None:
        if request.event:
            self._kernel32.CloseHandle(ctypes.c_void_p(request.event))
            request.event = None

    def read_async(self, request: WinIoRequest) -> bool:
        return bool(
            self._call(
                V_READ_DATA,
                BOOL,
                ctypes.POINTER(IO_REQUEST_LUSBAPI),
                args=(ctypes.byref(request.struct),),
            )
        )

    def wait(self, request: WinIoRequest, timeout_ms: int) -> int:
        if not request.event:
            return WAIT_TIMEOUT
        status = int(
            self._kernel32.WaitForSingleObject(
                ctypes.c_void_p(request.event), timeout_ms & 0xFFFFFFFF
            )
        )
        if status == WAIT_OBJECT_0:
            transferred = DWORD()
            ok = self._kernel32.GetOverlappedResult(
                ctypes.c_void_p(self._get_device_handle()),
                ctypes.byref(request.overlapped),
                ctypes.byref(transferred),
                False,
            )
            if ok:
                request.transferred = int(transferred.value) // 2
            else:
                # ReadData() stores NumberOfWordsPassed at submission time and
                # may leave it at zero for async I/O; fall back to the full
                # buffer like the MATLAB wrapper does.
                passed = int(request.struct.NumberOfWordsPassed)
                request.transferred = passed or request.capacity
        return status

    def request_words_passed(self, request: WinIoRequest) -> int:
        if request.transferred is not None:
            return min(request.transferred, request.capacity)
        return int(request.struct.NumberOfWordsPassed) or request.capacity

    def request_data(self, request: WinIoRequest) -> array.array:
        count = self.request_words_passed(request)
        if count <= 0:
            return array.array("h")
        view = memoryview(request.buffer)[:count]
        result = array.array("h")
        result.frombytes(bytes(view))
        return result


def _load_dll(dll_path: Any) -> tuple[Any, Path]:
    path = Path(dll_path) if dll_path is not None else find_lusbapi64()
    if path.is_file():
        directory = str(path.parent)
        if hasattr(os, "add_dll_directory"):
            os.add_dll_directory(directory)
        dll = ctypes.WinDLL(str(path))  # type: ignore[attr-defined]
    else:
        # Let Windows resolve the DLL from PATH; error text stays readable.
        dll = ctypes.WinDLL(str(path))  # type: ignore[attr-defined]
    return dll, path


__all__ = ["WindowsBackend", "WinIoRequest", "find_lusbapi64"]
