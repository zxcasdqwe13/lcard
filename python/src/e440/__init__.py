"""Python control and acquisition for the LCard E14-440 (ADSP-2181 LBIOS)."""

from __future__ import annotations

from .acquisition import (
    DEFAULT_BUFFER_WORDS,
    DEFAULT_TIMEOUT_MS,
    collect_blocks,
    deinterleave,
    iter_blocks,
    to_numpy,
)
from .backend.base import BackendUnavailable
from .backend.mock import MockBackend
from .device import E440
from .dsp import (
    DAC_AMP_ADDR,
    DECIM_ADDR,
    FIR_COEF1_ADDR,
    FIR_COEF2_ADDR,
    IIR_B_COEF_ADDR,
    N2TAPS_ADDR,
    NTAPS_ADDR,
    PROC_SWITCH_ADDR,
    SHIFT_ADDR,
    FilterConfig,
    decimation_word,
    float_to_q15,
    pm_pack,
    pm_unpack,
    q15_array,
    q15_to_float,
)
from .exceptions import E440Closed, E440Error, E440NotFound, E440Timeout
from .filter_model import (
    ComparisonResult,
    FilterCapture,
    FilterModel,
    FilterModelConfig,
    compare_signals,
    estimate_bandwidth,
    load_capture,
    search_model,
)
from .filter_test import (
    FilterTestResult,
    MockLoopConfig,
    analyze_capture,
    auto_analyze,
    make_mock_capture,
    run_mock_test,
)
from .model import AdcBlock, AdcParams, DacParams, ModuleDescription

__version__ = "0.1.0"

__all__ = [
    "AdcBlock",
    "AdcParams",
    "BackendUnavailable",
    "ComparisonResult",
    "DacParams",
    "DEFAULT_BUFFER_WORDS",
    "DEFAULT_TIMEOUT_MS",
    "E440",
    "E440Closed",
    "E440Error",
    "E440NotFound",
    "E440Timeout",
    "FilterCapture",
    "FilterConfig",
    "FilterModel",
    "FilterModelConfig",
    "FilterTestResult",
    "MockBackend",
    "MockLoopConfig",
    "ModuleDescription",
    "analyze_capture",
    "auto_analyze",
    "collect_blocks",
    "compare_signals",
    "decimation_word",
    "estimate_bandwidth",
    "deinterleave",
    "float_to_q15",
    "iter_blocks",
    "load_capture",
    "make_mock_capture",
    "pm_pack",
    "pm_unpack",
    "q15_array",
    "q15_to_float",
    "run_mock_test",
    "search_model",
    "to_numpy",
]
