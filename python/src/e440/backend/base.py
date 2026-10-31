"""Backend interface: everything the high-level :class:`e440.E440` needs."""

from __future__ import annotations

from abc import ABC, abstractmethod
from typing import Any

from ..model import AdcParams, DacParams, ModuleDescription

WAIT_OBJECT_0 = 0x00000000
WAIT_TIMEOUT = 0x00000102


class BackendUnavailable(RuntimeError):
    """Raised when a backend cannot be used on the current platform."""


class Backend(ABC):
    """Low-level device interface.

    Implementations translate these calls to LCard's ``Lusbapi64.dll``
    (:mod:`e440.backend.windows`) or to an in-memory simulator
    (:mod:`e440.backend.mock`).
    """

    name = "base"

    @abstractmethod
    def open(self, slot: int) -> bool:
        """Open the device in *slot*; return ``True`` on success."""

    @abstractmethod
    def release(self) -> None:
        """Close the device and release the interface instance."""

    @abstractmethod
    def get_last_error(self) -> tuple[str, int]:
        """Return ``(message, number)`` for the last LCard operation."""

    @abstractmethod
    def load_bios(self, path: str | None) -> bool:
        """Load an LBIOS ``.BIO`` file (``None`` loads the built-in image)."""

    @abstractmethod
    def test_module(self) -> bool:
        ...

    @abstractmethod
    def send_command(self, command: int) -> bool:
        ...

    @abstractmethod
    def get_module_description(self) -> ModuleDescription:
        ...

    @abstractmethod
    def get_adc_params(self) -> AdcParams:
        ...

    @abstractmethod
    def set_adc_params(self, params: AdcParams) -> bool:
        ...

    @abstractmethod
    def start_adc(self) -> bool:
        ...

    @abstractmethod
    def stop_adc(self) -> bool:
        ...

    @abstractmethod
    def get_dac_params(self) -> DacParams:
        ...

    @abstractmethod
    def set_dac_params(self, params: DacParams) -> bool:
        ...

    @abstractmethod
    def start_dac(self) -> bool:
        ...

    @abstractmethod
    def stop_dac(self) -> bool:
        ...

    @abstractmethod
    def dac_sample(self, value: int, channel: int = 0) -> bool:
        ...

    @abstractmethod
    def enable_ttl_out(self, enable: bool) -> bool:
        ...

    @abstractmethod
    def ttl_out(self, value: int) -> bool:
        ...

    @abstractmethod
    def ttl_in(self) -> int | None:
        ...

    # -- DSP memory ---------------------------------------------------------

    @abstractmethod
    def put_pm_word(self, address: int, raw: int) -> bool:
        """Write a left-aligned 32-bit PM word (see :func:`e440.dsp.pm_pack`)."""

    @abstractmethod
    def get_pm_word(self, address: int) -> int | None:
        ...

    @abstractmethod
    def put_pm_array(self, address: int, raw: list[int]) -> bool:
        ...

    @abstractmethod
    def get_pm_array(self, address: int, count: int) -> list[int] | None:
        ...

    @abstractmethod
    def put_dm_word(self, address: int, value: int) -> bool:
        ...

    @abstractmethod
    def get_dm_word(self, address: int) -> int | None:
        ...

    @abstractmethod
    def get_dm_array(self, address: int, count: int) -> list[int] | None:
        ...

    # -- asynchronous ADC reads --------------------------------------------

    @abstractmethod
    def create_request(self, words: int, timeout_ms: int) -> Any:
        ...

    @abstractmethod
    def free_request(self, request: Any) -> None:
        ...

    @abstractmethod
    def read_async(self, request: Any) -> bool:
        ...

    @abstractmethod
    def wait(self, request: Any, timeout_ms: int) -> int:
        """Wait for completion; return a Win32 wait code (0 or 258)."""

    @abstractmethod
    def request_words_passed(self, request: Any) -> int:
        ...

    @abstractmethod
    def request_data(self, request: Any) -> Any:
        """Return the samples as ``array.array('h')`` (or a numpy array)."""


__all__ = ["Backend", "BackendUnavailable", "WAIT_OBJECT_0", "WAIT_TIMEOUT"]
