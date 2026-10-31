"""ADSP-2181 memory map and fixed-point helpers for the LCard E14-440.

The constants mirror ``ADI_DSP/CONST.H``; keep both files in sync.  Addressing
follows the LBIOS convention: variables live in data memory starting at
``VARIABLE_BASE`` and the program starts at ``PROGRAM_BASE``.  Program-memory
(PM) words are 24-bit and are transferred through the LCard API left-aligned
inside a 32-bit container, hence the ``<< 8`` / ``>> 8`` helpers below.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Iterable, Sequence

# ---------------------------------------------------------------------------
# Addresses
# ---------------------------------------------------------------------------

VARIABLE_BASE = 0x30
PROGRAM_BASE = 0x400

# LBIOS variables (CONST.H, VariableBaseAddress + offset).
PROGRAM_BASE_ADDR = VARIABLE_BASE + 0x00
READY_ADDR = VARIABLE_BASE + 0x01
TMODE1_ADDR = VARIABLE_BASE + 0x02
TMODE2_ADDR = VARIABLE_BASE + 0x03
TEST_LOAD_ADDR = VARIABLE_BASE + 0x04
COMMAND_ADDR = VARIABLE_BASE + 0x05
IMASK_VALUE_ADDR = VARIABLE_BASE + 0x06
SCLK0_DIV_ADDR = VARIABLE_BASE + 0x07
DAC_RATE_ADDR = VARIABLE_BASE + 0x08
ADC_RATE_ADDR = VARIABLE_BASE + 0x09
ADC_ENABLE_ADDR = VARIABLE_BASE + 0x0A
ADC_FIFO_BASE_ADDR = VARIABLE_BASE + 0x0B
CUR_ADC_FIFO_LENGTH_ADDR = VARIABLE_BASE + 0x0C
ADC_FIFO_LENGTH_OVER_2_ADDR = VARIABLE_BASE + 0x0D
ADC_FIFO_LENGTH_ADDR = VARIABLE_BASE + 0x0E
CORRECTION_ENABLED_ADDR = VARIABLE_BASE + 0x0F
ADC_SAMPLE_ADDR = VARIABLE_BASE + 0x11
ADC_CHANNEL_ADDR = VARIABLE_BASE + 0x12
INPUT_MODE_ADDR = VARIABLE_BASE + 0x13
CONTROL_TABLE_LENGTH_ADDR = VARIABLE_BASE + 0x1B
FIRST_SAMPLE_DELAY_ADDR = VARIABLE_BASE + 0x1C
INTER_KADR_DELAY_ADDR = VARIABLE_BASE + 0x1D
DAC_SAMPLE_ADDR = VARIABLE_BASE + 0x20
DAC_ENABLE_ADDR = VARIABLE_BASE + 0x21
DAC_FIFO_BASE_ADDR = VARIABLE_BASE + 0x22
DAC_FIFO_LENGTH_OVER_2_ADDR = VARIABLE_BASE + 0x23
CUR_DAC_FIFO_LENGTH_ADDR = VARIABLE_BASE + 0x24
DAC_FIFO_LENGTH_ADDR = VARIABLE_BASE + 0x25
ENABLE_FLASH_ADDR = VARIABLE_BASE + 0x26
FLASH_ADDRESS_ADDR = VARIABLE_BASE + 0x27
FLASH_DATA_ADDR = VARIABLE_BASE + 0x28
ENABLE_TTL_OUT_ADDR = VARIABLE_BASE + 0x29
TTL_OUT_ADDR = VARIABLE_BASE + 0x2A
TTL_IN_ADDR = VARIABLE_BASE + 0x2B
SCALE_FACTOR_ADDR = VARIABLE_BASE + 0x30
ZERO_OFFSET_ADDR = VARIABLE_BASE + 0x34
PREV_FILT_VALUE_ADDR = VARIABLE_BASE + 0x35
COUNTER_ADDR = VARIABLE_BASE + 0x36
COUNTER_DURATION_ADDR = VARIABLE_BASE + 0x37
DELAY_TTL_ADDR = VARIABLE_BASE + 0x38
DURATION_TTL_ADDR = VARIABLE_BASE + 0x39
FILT_BUF_ADDR = VARIABLE_BASE + 0x40

# Filter parameters used by the MATLAB scripts.
N2TAPS_ADDR = VARIABLE_BASE + 0x42
NTAPS_ADDR = VARIABLE_BASE + 0x4B
DAC_AMP_ADDR = VARIABLE_BASE + 0x4C
SHIFT_ADDR = VARIABLE_BASE + 0x4D
PROC_SWITCH_ADDR = VARIABLE_BASE + 0x4E
DECIM_ADDR = VARIABLE_BASE + 0x4F

# Arrays in program memory.
CONTROL_TABLE_ADDR = 0x80
CALIBRATION_ARRAY_ADDR = 0x100
DSP_INFO_STRUCT_ADDR = 0x200
FIR_COEF1_ADDR = 0x300
FIR_COEF2_ADDR = 0x380
IIR_B_COEF_ADDR = 0x3C0

FIR_TAPS = 64
IIR_TAPS = 8
CONTROL_TABLE_LENGTH = 128

# DSP data-memory addresses used by check_filt()/read_dac_history().
DAC_HISTORY_BASE = 0x3FD0
DAC_HISTORY_POS_ADDR = VARIABLE_BASE + 0x42

# ---------------------------------------------------------------------------
# Program-memory packing
# ---------------------------------------------------------------------------

PM_WORD_MASK = 0x00FF_FFFF
PM_ALIGN_SHIFT = 8


def pm_pack(value: int) -> int:
    """Convert a 24-bit PM value to the left-aligned 32-bit API word."""
    return (int(value) & PM_WORD_MASK) << PM_ALIGN_SHIFT


def pm_unpack(raw: int) -> int:
    """Convert a left-aligned 32-bit API word back to a 24-bit PM value."""
    return (int(raw) >> PM_ALIGN_SHIFT) & PM_WORD_MASK


def pm_pack_array(values: Iterable[int]) -> list[int]:
    return [pm_pack(value) for value in values]


def pm_unpack_array(values: Iterable[int]) -> list[int]:
    return [pm_unpack(value) for value in values]


# ---------------------------------------------------------------------------
# Q15 (1.15) fixed point
# ---------------------------------------------------------------------------

Q15_ONE = 1 << 15
Q15_MIN = -Q15_ONE
Q15_MAX = Q15_ONE - 1


def float_to_q15(value: float, saturate: bool = True) -> int:
    """Convert a float in [-1, 1) to an unsigned 16-bit Q15 bit pattern."""
    raw = int(round(float(value) * Q15_ONE))
    if saturate:
        raw = max(Q15_MIN, min(Q15_MAX, raw))
    return raw & 0xFFFF


def q15_to_float(value: int) -> float:
    """Convert a 16-bit Q15 bit pattern to float."""
    value &= 0xFFFF
    if value & 0x8000:
        value -= 0x10000
    return value / Q15_ONE


def q15_array(values: Iterable[float], saturate: bool = True) -> list[int]:
    """Convert a sequence of floats to Q15 bit patterns (MATLAB ``fi`` analog)."""
    return [float_to_q15(value, saturate) for value in values]


def to_signed16(value: int) -> int:
    """Interpret the low 16 bits of *value* as a signed integer."""
    value &= 0xFFFF
    return value - 0x10000 if value & 0x8000 else value


# ---------------------------------------------------------------------------
# Filter configuration
# ---------------------------------------------------------------------------


def decimation_word(decimation: int, channels: int = 2) -> int:
    """Return the negative ADC step stored in ``DecimAddr``.

    The DSP uses ``M = DecimAddr`` as an index step in ADC samples.  For two
    channels one output frame advances by ``channels`` samples per decimation
    step, therefore the step is ``-(decimation * channels)``.  The result is
    returned as an unsigned 16-bit word (e.g. ``decimation=10, channels=2``
    gives ``0xFFEC``).
    """
    if decimation < 1:
        raise ValueError("decimation must be >= 1")
    if channels < 1:
        raise ValueError("channels must be >= 1")
    step = decimation * channels
    if step > 0xFFFF:
        raise ValueError("decimation * channels does not fit into 16 bits")
    return (0x10000 - step) & 0xFFFF


@dataclass
class FilterConfig:
    """Parameters written into LBIOS PM memory before acquisition.

    ``fir_coef1`` / ``fir_coef2`` / ``iir_coefs`` are Q15 bit patterns as
    unsigned 16-bit integers (the same values MATLAB's ``fi`` produces).
    ``decim_word`` may be set explicitly to reproduce legacy scripts; when it
    is ``None`` it is derived from ``decimation`` and ``channels``.
    """

    ntaps: int = 32
    n2taps: int = 8
    dac_amp: int = 0xFFFF
    shift: int = 0xFFFF
    proc_switch: int = 1
    decimation: int | None = 10
    channels: int = 2
    decim_word: int | None = None
    fir_coef1: Sequence[int] = field(default_factory=lambda: [0] * FIR_TAPS)
    fir_coef2: Sequence[int] | None = None
    iir_coefs: Sequence[int] = field(default_factory=lambda: [0] * IIR_TAPS)

    def __post_init__(self) -> None:
        if self.decim_word is None:
            if self.decimation is None:
                raise ValueError("either decimation or decim_word is required")
            self.decim_word = decimation_word(self.decimation, self.channels)
        self.decim_word &= 0xFFFF
        self.fir_coef1 = [int(value) & 0xFFFF for value in self.fir_coef1]
        if self.fir_coef2 is not None:
            self.fir_coef2 = [int(value) & 0xFFFF for value in self.fir_coef2]
        self.iir_coefs = [int(value) & 0xFFFF for value in self.iir_coefs]

    @classmethod
    def from_floats(
        cls,
        fir: Sequence[float],
        iir: Sequence[float] = (),
        **kwargs: object,
    ) -> "FilterConfig":
        """Build a config from floating-point coefficients in [-1, 1)."""
        fir_words = q15_array(fir)
        iir_words = q15_array(iir)
        if len(fir_words) > FIR_TAPS:
            raise ValueError(f"at most {FIR_TAPS} FIR coefficients are supported")
        if len(iir_words) > IIR_TAPS:
            raise ValueError(f"at most {IIR_TAPS} IIR coefficients are supported")
        fir_words.extend([0] * (FIR_TAPS - len(fir_words)))
        iir_words.extend([0] * (IIR_TAPS - len(iir_words)))
        return cls(fir_coef1=fir_words, iir_coefs=iir_words, **kwargs)  # type: ignore[arg-type]

    def scalar_words(self) -> dict[int, int]:
        """Return the scalar PM address/value pairs for this config."""
        return {
            NTAPS_ADDR: self.ntaps & 0xFFFF,
            N2TAPS_ADDR: self.n2taps & 0xFFFF,
            DAC_AMP_ADDR: self.dac_amp & 0xFFFF,
            SHIFT_ADDR: self.shift & 0xFFFF,
            PROC_SWITCH_ADDR: self.proc_switch & 0xFFFF,
            DECIM_ADDR: self.decim_word,
        }


__all__ = [
    "FilterConfig",
    "PM_ALIGN_SHIFT",
    "PM_WORD_MASK",
    "Q15_ONE",
    "decimation_word",
    "float_to_q15",
    "pm_pack",
    "pm_pack_array",
    "pm_unpack",
    "pm_unpack_array",
    "q15_array",
    "q15_to_float",
    "to_signed16",
]
