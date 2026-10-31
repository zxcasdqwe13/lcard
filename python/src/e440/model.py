"""Platform-independent data models returned by the backends."""

from __future__ import annotations

from dataclasses import dataclass, field

from .dsp import CONTROL_TABLE_LENGTH


@dataclass
class AdcParams:
    """ADC settings mirrored from ``ADC_PARS_E440``."""

    is_adc_enabled: bool = False
    is_correction_enabled: bool = False
    adc_clock_source: int = 0
    input_mode: int = 0
    synchro_ad_type: int = 0
    synchro_ad_mode: int = 0
    synchro_ad_channel: int = 0
    synchro_ad_porog: int = 0
    channels: int = 2
    control_table: list[int] = field(
        default_factory=lambda: [0] * CONTROL_TABLE_LENGTH
    )
    adc_rate: float = 200.0
    inter_kadr_delay: float = 0.0
    kadr_rate: float = 0.0
    adc_fifo_base_address: int = 0
    adc_fifo_length: int = 0
    adc_offset_coefs: list[float] = field(default_factory=lambda: [0.0] * 4)
    adc_scale_coefs: list[float] = field(default_factory=lambda: [0.0] * 4)

    def __post_init__(self) -> None:
        self.control_table = list(self.control_table)
        self.adc_offset_coefs = list(self.adc_offset_coefs)
        self.adc_scale_coefs = list(self.adc_scale_coefs)
        if len(self.control_table) != CONTROL_TABLE_LENGTH:
            raise ValueError(
                f"control_table must have {CONTROL_TABLE_LENGTH} entries, "
                f"got {len(self.control_table)}"
            )
        if len(self.adc_offset_coefs) != 4 or len(self.adc_scale_coefs) != 4:
            raise ValueError("ADC calibration arrays must have 4 entries")


@dataclass
class DacParams:
    dac_enabled: bool = False
    dac_rate: float = 0.0
    dac_fifo_base_address: int = 0
    dac_fifo_length: int = 0


@dataclass
class ModuleDescription:
    """Flattened, printable subset of ``MODULE_DESCRIPTION_E440``."""

    company_name: str = ""
    device_name: str = ""
    serial_number: str = ""
    revision: int = 0
    modification: int = 0
    comment: str = ""
    dsp_name: str = ""
    dsp_clock_rate: float = 0.0
    dsp_version: str = ""
    mcu_name: str = ""
    mcu_version: str = ""
    adc_name: str = ""
    dac_name: str = ""
    interface_name: str = ""
    digital_io_name: str = ""

    def summary(self) -> str:
        parts = [
            f"{self.company_name} {self.device_name}".strip(),
            f"serial={self.serial_number}" if self.serial_number else "",
            f"DSP={self.dsp_name}" if self.dsp_name else "",
            f"ADC={self.adc_name}" if self.adc_name else "",
        ]
        return " | ".join(part for part in parts if part)


@dataclass
class AdcBlock:
    """One buffer returned by the asynchronous acquisition loop."""

    index: int
    samples: object  # array.array("h") or numpy.ndarray
    words_passed: int

    def __len__(self) -> int:
        return len(self.samples)  # type: ignore[arg-type]

    def __iter__(self):
        return iter(self.samples)  # type: ignore[arg-type]

    def __getitem__(self, item):
        return self.samples[item]  # type: ignore[index]


__all__ = ["AdcBlock", "AdcParams", "DacParams", "ModuleDescription"]
