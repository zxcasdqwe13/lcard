"""In-memory E14-440 simulator for tests and development without hardware."""

from __future__ import annotations

import array
import math
import random
from dataclasses import dataclass
from ..dsp import (
    DAC_AMP_ADDR,
    DECIM_ADDR,
    FIR_COEF1_ADDR,
    IIR_B_COEF_ADDR,
    N2TAPS_ADDR,
    NTAPS_ADDR,
    PROC_SWITCH_ADDR,
    SHIFT_ADDR,
)
from ..model import AdcParams, DacParams, ModuleDescription
from .base import Backend, WAIT_OBJECT_0


@dataclass
class MockIoRequest:
    buffer: array.array
    capacity: int
    timeout_ms: int
    pending: bool = False
    words_passed: int = 0


class MockBackend(Backend):
    """Deterministic simulator: opens slot 0 and streams a two-tone signal."""

    name = "mock"

    def __init__(self, *, amplitude: int = 12000, noise: int = 50) -> None:
        self.amplitude = amplitude
        self.noise = noise
        self.opened = False
        self.released = False
        self.bios_path: str | None = None
        self.pm: dict[int, int] = {
            NTAPS_ADDR: 32,
            N2TAPS_ADDR: 8,
            DAC_AMP_ADDR: 0xFFFF,
            SHIFT_ADDR: 0xFFFF,
            PROC_SWITCH_ADDR: 1,
            DECIM_ADDR: 0xFFEC,
            FIR_COEF1_ADDR: 0,
            IIR_B_COEF_ADDR: 0,
        }
        self.dm: dict[int, int] = {}
        self.adc = AdcParams()
        self.dac = DacParams()
        self.dac_samples: list[tuple[int, int]] = []
        self.ttl_value = 0
        self.ttl_enabled = False
        self.adc_running = False
        self.last_error = ("No error", 100)
        self._sample_index = 0
        self._rng = random.Random(0xE440)

    # -- lifecycle ---------------------------------------------------------

    def open(self, slot: int) -> bool:
        if slot != 0:
            self.last_error = (f"Mock backend has no device in slot {slot}", 13)
            return False
        self.opened = True
        self.released = False
        self.last_error = ("No error", 100)
        return True

    def release(self) -> None:
        self.opened = False
        self.released = True
        self.adc_running = False

    def get_last_error(self) -> tuple[str, int]:
        return self.last_error

    def load_bios(self, path: str | None) -> bool:
        self.bios_path = path
        if path is not None:
            from pathlib import Path

            if not Path(path).is_file():
                self.last_error = (f"BIOS file not found: {path}", 11)
                return False
        self.last_error = ("No error", 100)
        return True

    def test_module(self) -> bool:
        return True

    def send_command(self, command: int) -> bool:
        return True

    def get_module_description(self) -> ModuleDescription:
        return ModuleDescription(
            company_name="L-Card",
            device_name="E14-440",
            serial_number="MOCK0001",
            revision=1,
            modification=0,
            comment="mock backend",
            dsp_name="ADSP-2181",
            dsp_clock_rate=24.0e6,
            dsp_version="mock",
            mcu_name="MCU",
            mcu_version="mock",
            adc_name="ADC mock",
            dac_name="DAC mock",
            interface_name="USB",
            digital_io_name="TTL",
        )

    # -- ADC / DAC ---------------------------------------------------------

    def get_adc_params(self) -> AdcParams:
        return AdcParams(**vars(self.adc))

    def set_adc_params(self, params: AdcParams) -> bool:
        self.adc = AdcParams(**vars(params))
        return True

    def start_adc(self) -> bool:
        self.adc_running = True
        return True

    def stop_adc(self) -> bool:
        self.adc_running = False
        return True

    def get_dac_params(self) -> DacParams:
        return DacParams(**vars(self.dac))

    def set_dac_params(self, params: DacParams) -> bool:
        self.dac = DacParams(**vars(params))
        return True

    def start_dac(self) -> bool:
        return True

    def stop_dac(self) -> bool:
        return True

    def dac_sample(self, value: int, channel: int = 0) -> bool:
        self.dac_samples.append((value, channel))
        return True

    def enable_ttl_out(self, enable: bool) -> bool:
        self.ttl_enabled = bool(enable)
        return True

    def ttl_out(self, value: int) -> bool:
        self.ttl_value = value & 0xFFFF
        return True

    def ttl_in(self) -> int | None:
        return 0

    # -- DSP memory --------------------------------------------------------

    def put_pm_word(self, address: int, raw: int) -> bool:
        self.pm[address & 0xFFFF] = raw & 0xFFFFFFFF
        return True

    def get_pm_word(self, address: int) -> int | None:
        return self.pm.get(address & 0xFFFF, 0)

    def put_pm_array(self, address: int, raw: list[int]) -> bool:
        for offset, value in enumerate(raw):
            self.pm[(address + offset) & 0xFFFF] = value & 0xFFFFFFFF
        return True

    def get_pm_array(self, address: int, count: int) -> list[int] | None:
        return [self.pm.get((address + offset) & 0xFFFF, 0) for offset in range(count)]

    def put_dm_word(self, address: int, value: int) -> bool:
        self.dm[address & 0xFFFF] = value
        return True

    def get_dm_word(self, address: int) -> int | None:
        return self.dm.get(address & 0xFFFF, 0)

    def get_dm_array(self, address: int, count: int) -> list[int] | None:
        return [self.dm.get((address + offset) & 0xFFFF, 0) for offset in range(count)]

    # -- asynchronous reads ------------------------------------------------

    def create_request(self, words: int, timeout_ms: int) -> MockIoRequest:
        # Match the clamping done by TLE440::ReadData().
        words = max(0x20, min(words, 1024 * 1024))
        words -= words % 0x20
        return MockIoRequest(
            buffer=array.array("h", [0]) * words,
            capacity=words,
            timeout_ms=timeout_ms,
        )

    def free_request(self, request: MockIoRequest) -> None:
        request.pending = False

    def read_async(self, request: MockIoRequest) -> bool:
        request.pending = True
        request.words_passed = request.capacity
        return True

    def wait(self, request: MockIoRequest, timeout_ms: int) -> int:
        if request.pending:
            self._fill(request)
            request.pending = False
        return WAIT_OBJECT_0

    def request_words_passed(self, request: MockIoRequest) -> int:
        return request.words_passed

    def request_data(self, request: MockIoRequest) -> array.array:
        count = min(request.words_passed, request.capacity)
        return array.array("h", request.buffer[:count])

    # -- signal generator --------------------------------------------------

    def _fill(self, request: MockIoRequest) -> None:
        rate = self.adc.adc_rate or 200.0
        channels = max(1, self.adc.channels)
        for index in range(request.capacity):
            sample_index = self._sample_index + index
            channel = sample_index % channels
            t = sample_index / (rate * channels)
            freq = 50.0 if channel == 0 else 120.0
            value = self.amplitude * math.sin(2.0 * math.pi * freq * t)
            if self.noise:
                value += self._rng.uniform(-self.noise, self.noise)
            request.buffer[index] = max(-32768, min(32767, int(value)))
        self._sample_index += request.capacity


__all__ = ["MockBackend", "MockIoRequest"]
