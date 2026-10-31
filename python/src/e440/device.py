"""High-level E14-440 control built on a pluggable backend."""

from __future__ import annotations

import array
from typing import Iterable, Iterator, Sequence

from .acquisition import (
    DEFAULT_BUFFER_WORDS,
    DEFAULT_TIMEOUT_MS,
    collect_blocks,
    iter_blocks,
)
from .backend.base import Backend
from .dsp import (
    CONTROL_TABLE_LENGTH,
    DAC_HISTORY_BASE,
    FIR_COEF1_ADDR,
    FIR_COEF2_ADDR,
    FilterConfig,
    IIR_B_COEF_ADDR,
    N2TAPS_ADDR,
    pm_pack,
    pm_unpack,
)
from .exceptions import E440Closed, E440Error, E440NotFound
from .model import AdcParams, DacParams, ModuleDescription


class E440:
    """Convenience wrapper around an LCard E14-440 backend."""

    def __init__(self, backend: Backend) -> None:
        self.backend = backend
        self._closed = False
        self._description: ModuleDescription | None = None

    # -- lifecycle ---------------------------------------------------------

    @classmethod
    def open(
        cls,
        slots: Iterable[int] = range(10),
        *,
        backend: Backend | None = None,
        dll_path: str | None = None,
    ) -> "E440":
        """Create the interface and open the first available slot.

        On Windows *backend* defaults to :class:`WindowsBackend`, which loads
        ``Lusbapi64.dll`` and requires the L-Card USB driver.
        """
        if backend is None:
            from .backend.windows import WindowsBackend

            backend = WindowsBackend(dll_path=dll_path)

        tried: list[int] = []
        for slot in slots:
            tried.append(slot)
            if backend.open(slot):
                return cls(backend)

        message, number = backend.get_last_error()
        backend.release()
        raise E440NotFound(
            f"no E14-440 found in slots {tried}: {message}",
            action="OpenLDevice",
            error_number=number,
        )

    def close(self) -> None:
        """Release the device (``ReleaseLInstance`` deletes the C++ object)."""
        if self._closed:
            return
        self._closed = True
        self.backend.release()

    def __enter__(self) -> "E440":
        return self

    def __exit__(self, exc_type, exc, tb) -> None:
        self.close()

    def __repr__(self) -> str:
        state = "closed" if self._closed else "open"
        return f"<E440 {state} backend={self.backend.name}>"

    def _require_open(self) -> None:
        if self._closed:
            raise E440Closed("device is closed", action="E440")

    def _check(self, ok: bool, action: str) -> bool:
        if not ok:
            message, number = self.backend.get_last_error()
            raise E440Error(message, action=action, error_number=number)
        return True

    def last_error(self) -> tuple[str, int]:
        return self.backend.get_last_error()

    # -- firmware / identity ----------------------------------------------

    def load_bios(self, path: str | None = None) -> None:
        """Load LBIOS from *path* (``None`` uses the DLL's built-in image)."""
        self._require_open()
        self._check(self.backend.load_bios(path), "LOAD_MODULE")

    def test_module(self) -> None:
        self._require_open()
        self._check(self.backend.test_module(), "TEST_MODULE")

    def send_command(self, command: int) -> None:
        self._require_open()
        self._check(self.backend.send_command(command), "SEND_COMMAND")

    @property
    def description(self) -> ModuleDescription:
        self._require_open()
        if self._description is None:
            self._description = self.backend.get_module_description()
        return self._description

    # -- ADC ---------------------------------------------------------------

    def get_adc_params(self) -> AdcParams:
        self._require_open()
        return self.backend.get_adc_params()

    def set_adc_params(self, params: AdcParams) -> AdcParams:
        self._require_open()
        self._check(self.backend.set_adc_params(params), "SET_ADC_PARS")
        return self.backend.get_adc_params()

    def configure_adc(
        self,
        *,
        rate: float | None = None,
        channels: int | None = None,
        inter_kadr_delay: float | None = None,
        control_table: Sequence[int] | None = None,
        correction: bool | None = None,
        clock_source: int | None = None,
        input_mode: int | None = None,
    ) -> AdcParams:
        """Read-modify-write ADC parameters and return the actual values.

        Parameters not supplied keep their current device values.  The MATLAB
        scripts call ``STOP_ADC`` before this, so the wrapper does the same.
        """
        self._require_open()
        self.backend.stop_adc()
        params = self.backend.get_adc_params()
        if rate is not None:
            params.adc_rate = float(rate)
        if channels is not None:
            params.channels = int(channels)
        if inter_kadr_delay is not None:
            params.inter_kadr_delay = float(inter_kadr_delay)
        if control_table is not None:
            # MATLAB's arr_def() overwrites only the supplied prefix and keeps
            # the remaining device entries, so do the same.
            values = [int(value) & 0xFFFF for value in control_table]
            if len(values) > CONTROL_TABLE_LENGTH:
                raise ValueError(
                    f"control_table is limited to {CONTROL_TABLE_LENGTH} entries"
                )
            table = list(params.control_table)
            table[: len(values)] = values
            params.control_table = table
        if correction is not None:
            params.is_correction_enabled = bool(correction)
        if clock_source is not None:
            params.adc_clock_source = int(clock_source)
        if input_mode is not None:
            params.input_mode = int(input_mode)
        return self.set_adc_params(params)

    def start_adc(self) -> None:
        self._require_open()
        self._check(self.backend.start_adc(), "START_ADC")

    def stop_adc(self) -> None:
        self._require_open()
        self._check(self.backend.stop_adc(), "STOP_ADC")

    def acquire_blocks(
        self,
        blocks: int,
        *,
        timeout_ms: int = DEFAULT_TIMEOUT_MS,
        buffer_words: int = DEFAULT_BUFFER_WORDS,
        start: bool = True,
        stop: bool = True,
    ) -> Iterator:
        """Yield :class:`~e440.model.AdcBlock` objects (double buffering)."""
        self._require_open()
        return iter_blocks(
            self.backend,
            blocks=blocks,
            timeout_ms=timeout_ms,
            buffer_words=buffer_words,
            start=start,
            stop=stop,
        )

    def acquire_all(
        self,
        blocks: int,
        *,
        timeout_ms: int = DEFAULT_TIMEOUT_MS,
        buffer_words: int = DEFAULT_BUFFER_WORDS,
    ) -> array.array:
        self._require_open()
        return collect_blocks(
            self.backend,
            blocks=blocks,
            timeout_ms=timeout_ms,
            buffer_words=buffer_words,
        )

    # -- DAC / TTL ---------------------------------------------------------

    def get_dac_params(self) -> DacParams:
        self._require_open()
        return self.backend.get_dac_params()

    def set_dac_params(self, params: DacParams) -> DacParams:
        self._require_open()
        self._check(self.backend.set_dac_params(params), "SET_DAC_PARS")
        return self.backend.get_dac_params()

    def dac_sample(self, value: int, channel: int = 0) -> None:
        self._require_open()
        self._check(self.backend.dac_sample(value, channel), "DAC_SAMPLE")

    def enable_ttl_out(self, enable: bool) -> None:
        self._require_open()
        self._check(self.backend.enable_ttl_out(enable), "ENABLE_TTL_OUT")

    def ttl_out(self, value: int) -> None:
        self._require_open()
        self._check(self.backend.ttl_out(value), "TTL_OUT")

    def ttl_in(self) -> int:
        self._require_open()
        value = self.backend.ttl_in()
        if value is None:
            self._check(False, "TTL_IN")
        return int(value)  # type: ignore[arg-type]

    # -- DSP program/data memory ------------------------------------------

    def read_pm_word(self, address: int) -> int:
        self._require_open()
        raw = self.backend.get_pm_word(address)
        if raw is None:
            self._check(False, "GET_PM_WORD")
        return pm_unpack(raw)  # type: ignore[arg-type]

    def write_pm_word(self, address: int, value: int, *, verify: bool = True) -> None:
        self._require_open()
        raw = pm_pack(value)
        self._check(self.backend.put_pm_word(address, raw), "PUT_PM_WORD")
        if verify:
            expected = pm_unpack(raw)
            actual = self.read_pm_word(address)
            if actual != expected:
                raise E440Error(
                    f"PM write verification failed at 0x{address:04X}: "
                    f"wrote 0x{expected:06X}, read 0x{actual:06X}",
                    action="PUT_PM_WORD",
                )

    def read_pm_array(self, address: int, count: int) -> list[int]:
        self._require_open()
        raw = self.backend.get_pm_array(address, count)
        if raw is None:
            self._check(False, "GET_PM_ARRAY")
        return [pm_unpack(value) for value in raw]  # type: ignore[union-attr]

    def write_pm_array(
        self, address: int, values: Iterable[int], *, verify_last: bool = True
    ) -> None:
        self._require_open()
        data = [int(value) & 0xFFFFFF for value in values]
        if not data:
            return
        raw = [pm_pack(value) for value in data]
        self._check(self.backend.put_pm_array(address, raw), "PUT_PM_ARRAY")
        if verify_last:
            actual = self.read_pm_word(address + len(data) - 1)
            if actual != data[-1]:
                raise E440Error(
                    f"PM array verification failed at 0x{address + len(data) - 1:04X}: "
                    f"wrote 0x{data[-1]:06X}, read 0x{actual:06X}",
                    action="PUT_PM_ARRAY",
                )

    def write_iir_coefs(
        self, values: Sequence[int], address: int = IIR_B_COEF_ADDR
    ) -> None:
        """Write IIR coefficients word by word (as ``write_iir_coef`` does)."""
        for offset, value in enumerate(values):
            self.write_pm_word(address + offset, value)

    def apply_filters(self, config: FilterConfig) -> None:
        """Write scalar filter parameters and coefficient arrays."""
        self._require_open()
        for address, value in config.scalar_words().items():
            self.write_pm_word(address, value)
        self.write_pm_array(FIR_COEF1_ADDR, config.fir_coef1)
        if config.fir_coef2 is not None:
            self.write_pm_array(FIR_COEF2_ADDR, config.fir_coef2)
        self.write_iir_coefs(config.iir_coefs)

    def read_dm_word(self, address: int) -> int:
        self._require_open()
        value = self.backend.get_dm_word(address)
        if value is None:
            self._check(False, "GET_DM_WORD")
        return int(value)  # type: ignore[arg-type]

    def write_dm_word(self, address: int, value: int) -> None:
        self._require_open()
        self._check(self.backend.put_dm_word(address, value), "PUT_DM_WORD")

    def read_dm_array(self, address: int, count: int) -> list[int]:
        self._require_open()
        values = self.backend.get_dm_array(address, count)
        if values is None:
            self._check(False, "GET_DM_ARRAY")
        return list(values)  # type: ignore[arg-type]

    def read_dac_history(self, count: int = 8) -> list[int]:
        """Read the DAC history buffer used by MATLAB's ``check_filt``."""
        position = self.read_pm_word(N2TAPS_ADDR)
        _ = position - DAC_HISTORY_BASE  # kept for parity with check_filt()
        return self.read_dm_array(DAC_HISTORY_BASE, count)


__all__ = ["E440"]
