"""Fixed-point model of the LBIOS FIR/IIR filter chain.

The model reproduces the arithmetic used by ``ch1processor`` in
``ADI_DSP/ADC-fir.H``: Q15 coefficients, a 40-bit fractional accumulator,
one rounded final IIR term and optional 32-bit saturation.  It deliberately
works on *per-channel frames* (one sample of one ADC channel per step), not on
the interleaved ADC stream, because that is the sequence a capture normally
provides.

The firmware has two important quirks that the model exposes explicitly:

* the IIR history is addressed with the decimation step, so the feedback taps
  are sparse (``iir_delay + k * iir_step``);
* the value written back to the DAC FIFO is ``MR0`` while the inter-channel
  path uses ``MR1``.  Use ``word="mr0"`` to model the FIFO path and
  ``word="mr1"`` for the mathematically expected output.
"""

from __future__ import annotations

import csv
import json
import math
from dataclasses import dataclass, field, replace
from pathlib import Path
from typing import Iterable, Literal, Sequence

from .dsp import FIR_TAPS, IIR_TAPS, Q15_ONE, FilterConfig, to_signed16

Word = Literal["mr1", "mr0"]

ACC_SHIFT = 16
ACC_RND = 1 << 15
ACC_MIN = -(1 << 31)
ACC_MAX = (1 << 31) - 1


def _mul_ss(a: int, b: int) -> int:
    """Multiply two signed Q15 words in ADSP fractional mode."""
    return (to_signed16(a) * to_signed16(b)) << 1


def _mul_su(a: int, b: int) -> int:
    """Multiply signed Q15 by unsigned U1.15 (``0x8000`` is 1.0)."""
    return (to_signed16(a) * (int(b) & 0xFFFF)) << 1


def _saturate(acc: int) -> int:
    if acc > ACC_MAX:
        return ACC_MAX
    if acc < ACC_MIN:
        return ACC_MIN
    return acc


def accumulator_to_word(acc: int, word: Word = "mr1") -> int:
    """Return the signed 16-bit word selected from a 32-bit accumulator."""
    if word == "mr1":
        return to_signed16(acc >> ACC_SHIFT)
    if word == "mr0":
        return to_signed16(acc & 0xFFFF)
    raise ValueError(f"unknown accumulator word: {word!r}")


def _word(value: Word) -> Word:
    if value not in ("mr1", "mr0"):
        raise ValueError(f"unknown accumulator word: {value!r}")
    return value


def _at(values: Sequence[int], index: int) -> int:
    return 0 if index < 0 else int(values[index])


@dataclass
class FilterModelConfig:
    """Configuration of the firmware filter chain.

    All sequences are indexed in per-channel frames.  ``fir_delay`` is the
    delay of the first FIR tap, and ``iir_delay`` is the delay of the first
    feedback tap.  The firmware stores coefficients as unsigned 16-bit words;
    they are interpreted as signed Q15 here, as the DSP multiplier does.

    ``b0`` is the unsigned U1.15 coefficient applied to the current sample
    (``0x8000`` is 1.0).  In the firmware this term comes from the ADC
    calibration multiply that is still in ``MR`` when ``ch1processor`` is
    called.  With the default calibration it is ``0x8000``.

    ``word`` is the accumulator word written to the feedback history (the DAC
    FIFO in the current firmware), while ``output_word`` is the word returned
    as the observable output (defaults to ``word``).  The current
    ``ADC-fir.H`` stores ``MR0`` but sends ``MR1`` to the DAC via ``TX0``, so
    the matching configuration is ``word="mr0", output_word="mr1"``.
    """

    ntaps: int = 32
    n2taps: int = 8
    fir_coefs: Sequence[int] = field(default_factory=lambda: [0] * FIR_TAPS)
    iir_coefs: Sequence[int] = field(default_factory=lambda: [0] * IIR_TAPS)
    decimation: int = 10
    channels: int = 2
    input_delay: int = 0
    fir_delay: int | None = None
    fir_step: int | None = None
    iir_delay: int | None = None
    iir_step: int | None = None
    b0: int = Q15_ONE
    word: Word = "mr1"
    output_word: Word | None = None
    round_initial: bool = True
    saturate: bool = True

    def __post_init__(self) -> None:
        if self.decimation < 1:
            raise ValueError("decimation must be >= 1")
        if self.channels < 1:
            raise ValueError("channels must be >= 1")
        if not 0 <= self.ntaps <= len(self.fir_coefs):
            raise ValueError("ntaps must be between 0 and len(fir_coefs)")
        if not 0 <= self.n2taps <= len(self.iir_coefs):
            raise ValueError("n2taps must be between 0 and len(iir_coefs)")
        if self.fir_delay is None:
            self.fir_delay = self.decimation
        if self.fir_step is None:
            self.fir_step = self.decimation
        if self.iir_delay is None:
            # The firmware starts the feedback at I1-2 samples.  For two
            # channels that is exactly one frame; for one channel it is two.
            self.iir_delay = max(1, 2 // self.channels)
        if self.iir_step is None:
            self.iir_step = self.decimation
        if self.fir_delay < 0 or self.iir_delay < 1:
            raise ValueError("fir_delay must be >= 0 and iir_delay >= 1")
        if self.input_delay < 0:
            raise ValueError("input_delay must be >= 0")
        if self.fir_step < 1 or self.iir_step < 1:
            raise ValueError("steps must be >= 1")
        self.fir_coefs = [int(value) & 0xFFFF for value in self.fir_coefs]
        self.iir_coefs = [int(value) & 0xFFFF for value in self.iir_coefs]
        self.b0 = int(self.b0) & 0xFFFF
        self.word = _word(self.word)
        self.output_word = self.word if self.output_word is None else _word(self.output_word)

    @classmethod
    def from_floats(
        cls,
        fir: Sequence[float],
        iir: Sequence[float] = (),
        **kwargs: object,
    ) -> "FilterModelConfig":
        from .dsp import q15_array

        fir_words = q15_array(fir)
        iir_words = q15_array(iir)
        if len(fir_words) > FIR_TAPS:
            raise ValueError(f"at most {FIR_TAPS} FIR coefficients are supported")
        if len(iir_words) > IIR_TAPS:
            raise ValueError(f"at most {IIR_TAPS} IIR coefficients are supported")
        fir_words.extend([0] * (FIR_TAPS - len(fir_words)))
        iir_words.extend([0] * (IIR_TAPS - len(iir_words)))
        kwargs.setdefault("ntaps", len(fir))
        kwargs.setdefault("n2taps", len(iir))
        return cls(fir_coefs=fir_words, iir_coefs=iir_words, **kwargs)  # type: ignore[arg-type]

    @classmethod
    def from_filter_config(
        cls,
        config: FilterConfig,
        **overrides: object,
    ) -> "FilterModelConfig":
        """Build a model config from the device-side :class:`FilterConfig`."""
        if config.decimation is not None:
            decimation = config.decimation
        elif config.decim_word is not None:
            step = (-config.decim_word) & 0xFFFF
            decimation = max(1, step // max(1, config.channels))
        else:
            decimation = 1
        values: dict[str, object] = {
            "ntaps": config.ntaps,
            "n2taps": config.n2taps,
            "fir_coefs": list(config.fir_coef1),
            "iir_coefs": list(config.iir_coefs),
            "decimation": decimation,
            "channels": config.channels,
        }
        values.update(overrides)
        return cls(**values)  # type: ignore[arg-type]

    @property
    def fir_span(self) -> int:
        if self.ntaps == 0:
            return 0
        return self.fir_delay + (self.ntaps - 1) * self.fir_step  # type: ignore[operator]

    @property
    def iir_span(self) -> int:
        if self.n2taps == 0:
            return 0
        return self.iir_delay + (self.n2taps - 1) * self.iir_step  # type: ignore[operator]

    @property
    def required_history(self) -> int:
        return max(self.fir_span, self.iir_span, self.input_delay)

    def with_delays(
        self,
        *,
        fir_delay: int | None = None,
        iir_delay: int | None = None,
        fir_step: int | None = None,
        iir_step: int | None = None,
        input_delay: int | None = None,
        word: Word | None = None,
        output_word: Word | None = None,
    ) -> "FilterModelConfig":
        return replace(
            self,
            fir_delay=self.fir_delay if fir_delay is None else fir_delay,
            iir_delay=self.iir_delay if iir_delay is None else iir_delay,
            fir_step=self.fir_step if fir_step is None else fir_step,
            iir_step=self.iir_step if iir_step is None else iir_step,
            input_delay=self.input_delay if input_delay is None else input_delay,
            word=self.word if word is None else word,
            output_word=self.output_word if output_word is None else output_word,
        )


class FilterModel:
    """Sample-by-sample fixed-point model of ``ch1processor``."""

    def __init__(self, config: FilterModelConfig) -> None:
        self.config = config

    def accumulator(self, adc: Sequence[int], dac: Sequence[int], n: int) -> int:
        """Return the raw accumulator for output frame *n*.

        ``adc[n]`` is the current input sample and ``dac[n - k]`` is a past
        output sample.  Both sequences must be long enough for the configured
        delays.
        """
        config = self.config
        acc = _mul_su(_at(adc, n - config.input_delay), config.b0)
        if config.round_initial:
            acc += ACC_RND

        for index in range(config.ntaps):
            offset = config.fir_delay + index * config.fir_step  # type: ignore[operator]
            acc += _mul_ss(_at(adc, n - offset), config.fir_coefs[index])

        for index in range(config.n2taps):
            offset = config.iir_delay + index * config.iir_step  # type: ignore[operator]
            product = _mul_ss(_at(dac, n - offset), config.iir_coefs[index])
            if index == config.n2taps - 1:
                product += ACC_RND
            acc -= product

        if config.saturate and config.n2taps:
            acc = _saturate(acc)
        return acc

    def predict(self, adc: Sequence[int], dac: Sequence[int], n: int) -> int:
        return accumulator_to_word(self.accumulator(adc, dac, n), self.config.output_word)

    def predict_sequence(
        self,
        adc: Sequence[int],
        dac: Sequence[int],
        *,
        start: int | None = None,
    ) -> list[int]:
        """One-step prediction using recorded past outputs as feedback.

        This is the most direct model/device comparison: the model is driven by
        the recorded input and the recorded output history, so errors do not
        accumulate and a delay mismatch is visible immediately.  It requires
        the history and observable output words to be the same; use
        :meth:`simulate` for the mixed ``MR0`` history / ``MR1`` output path.
        """
        if self.config.word != self.config.output_word:
            raise ValueError(
                "one-step prediction needs the same history and output word; "
                "use simulate() for mixed words"
            )
        if len(adc) != len(dac):
            raise ValueError("adc and dac sequences must have the same length")
        first = self.config.required_history if start is None else start
        if first < 0:
            raise ValueError("start must be >= 0")
        out = [0] * len(adc)
        for index in range(first, len(adc)):
            out[index] = self.predict(adc, dac, index)
        return out

    def simulate(
        self,
        adc: Sequence[int],
        *,
        initial_dac: Sequence[int] | None = None,
        start: int = 0,
    ) -> list[int]:
        """Free-running model using its own past outputs for feedback.

        The feedback sequence is stored in ``config.word`` units; the returned
        sequence is in ``config.output_word`` units.  This models the current
        firmware path where the DAC FIFO receives ``MR0`` while ``TX0`` sends
        ``MR1``.
        """
        first = start
        if first < 0:
            raise ValueError("start must be >= 0")
        out = [0] * len(adc)
        history = [0] * len(adc)
        if initial_dac is not None:
            if len(initial_dac) != first:
                raise ValueError("initial_dac must contain exactly 'start' samples")
            out[:first] = [int(value) for value in initial_dac]
            history[:first] = [int(value) for value in initial_dac]
        for index in range(first, len(adc)):
            acc = self.accumulator(adc, history, index)
            out[index] = accumulator_to_word(acc, self.config.output_word)
            history[index] = accumulator_to_word(acc, self.config.word)
        return out


@dataclass
class ComparisonResult:
    """Metrics of a model/device comparison."""

    samples: int
    rmse: float
    nrmse: float
    max_abs_error: int
    correlation: float
    gain: float
    bias: float
    snr_db: float
    passed: bool
    model: list[int] = field(repr=False, default_factory=list)
    device: list[int] = field(repr=False, default_factory=list)

    def as_dict(self) -> dict[str, object]:
        return {
            "samples": self.samples,
            "rmse": self.rmse,
            "nrmse": self.nrmse if math.isfinite(self.nrmse) else None,
            "max_abs_error": self.max_abs_error,
            "correlation": self.correlation,
            "gain": self.gain,
            "bias": self.bias,
            "snr_db": self.snr_db if math.isfinite(self.snr_db) else None,
            "passed": self.passed,
        }


def estimate_bandwidth(
    samples: Sequence[int],
    sample_rate_hz: float,
    *,
    fraction: float = 0.99,
) -> float | None:
    """Return the frequency below which *fraction* of the input energy lies.

    Returns ``None`` when numpy is unavailable, the sequence is too short, or
    the signal is constant.  This is used to check whether the excitation
    actually covers the band of interest.
    """
    try:
        import numpy as np
    except ImportError:
        return None
    if sample_rate_hz <= 0 or len(samples) < 32:
        return None
    values = np.asarray(samples, dtype=np.float64)
    values = values - values.mean()
    window = np.hanning(len(values))
    spectrum = np.abs(np.fft.rfft(values * window))
    power = spectrum * spectrum
    total = float(power.sum())
    if total <= 0.0:
        return None
    cumulative = np.cumsum(power) / total
    freqs = np.fft.rfftfreq(len(values), 1.0 / sample_rate_hz)
    index = min(int(np.searchsorted(cumulative, fraction)), len(freqs) - 1)
    return float(freqs[index])


def _correlation(model: Sequence[float], device: Sequence[float]) -> float:
    count = len(model)
    if count == 0:
        return 0.0
    mean_model = sum(model) / count
    mean_device = sum(device) / count
    var_model = sum((value - mean_model) ** 2 for value in model) / count
    var_device = sum((value - mean_device) ** 2 for value in device) / count
    if var_model <= 0.0 or var_device <= 0.0:
        return 0.0
    covariance = sum(
        (model_value - mean_model) * (device_value - mean_device)
        for model_value, device_value in zip(model, device)
    ) / count
    return covariance / math.sqrt(var_model * var_device)


def compare_signals(
    device: Sequence[int],
    model: Sequence[int],
    *,
    fit_gain: bool = True,
    fit_bias: bool = True,
    min_correlation: float = 0.95,
    max_nrmse: float = 0.10,
    start: int = 0,
) -> ComparisonResult:
    """Compare a recorded device output with a model output.

    A linear gain/bias fit removes the unknown DAC/ADC scaling of the analog
    loop.  ``nrmse`` is the RMS error normalised by the device AC RMS.
    """
    if len(device) != len(model):
        raise ValueError("device and model sequences must have the same length")
    if start < 0 or start >= len(device):
        raise ValueError("start must point inside the sequences")

    device_values = [float(value) for value in device[start:]]
    model_values = [float(value) for value in model[start:]]
    count = len(device_values)
    if count == 0:
        raise ValueError("no samples to compare")

    mean_device = sum(device_values) / count
    mean_model = sum(model_values) / count
    var_model = sum((value - mean_model) ** 2 for value in model_values) / count
    var_device = sum((value - mean_device) ** 2 for value in device_values) / count
    covariance = sum(
        (model_value - mean_model) * (device_value - mean_device)
        for model_value, device_value in zip(model_values, device_values)
    ) / count

    gain = covariance / var_model if fit_gain and var_model > 0.0 else 1.0
    bias = mean_device - gain * mean_model if fit_bias else 0.0
    errors = [
        device_value - (gain * model_value + bias)
        for model_value, device_value in zip(model_values, device_values)
    ]
    rmse = math.sqrt(sum(value * value for value in errors) / count)
    device_rms = math.sqrt(var_device)
    nrmse = rmse / device_rms if device_rms > 0.0 else (0.0 if rmse == 0 else math.inf)
    correlation = _correlation(model_values, device_values)
    snr_db = (
        20.0 * math.log10(device_rms / rmse)
        if rmse > 0.0 and device_rms > 0.0
        else math.inf
    )
    max_abs_error = max((abs(round(value)) for value in errors), default=0)
    passed = correlation >= min_correlation and nrmse <= max_nrmse

    return ComparisonResult(
        samples=count,
        rmse=rmse,
        nrmse=nrmse,
        max_abs_error=max_abs_error,
        correlation=correlation,
        gain=gain,
        bias=bias,
        snr_db=snr_db,
        passed=passed,
        model=list(model),
        device=list(device),
    )


@dataclass
class SearchResult:
    config: FilterModelConfig
    comparison: ComparisonResult


def search_model(
    adc: Sequence[int],
    dac: Sequence[int],
    base: FilterModelConfig,
    *,
    fir_delays: Iterable[int] | None = None,
    iir_delays: Iterable[int] | None = None,
    words: Iterable[Word] = ("mr1", "mr0"),
    min_correlation: float = 0.95,
    max_nrmse: float = 0.10,
) -> SearchResult:
    """Find the delay/word combination with the best one-step prediction.

    The search uses one-step prediction with the recorded output history, so
    each candidate is scored independently and no model error accumulates.
    """
    fir_candidates = list(fir_delays) if fir_delays is not None else [base.fir_delay]
    iir_candidates = list(iir_delays) if iir_delays is not None else [base.iir_delay]
    best: SearchResult | None = None
    for word in words:
        for fir_delay in fir_candidates:
            for iir_delay in iir_candidates:
                config = base.with_delays(
                    fir_delay=fir_delay,
                    iir_delay=iir_delay,
                    word=word,
                    output_word=word,
                )
                model = FilterModel(config)
                if len(adc) <= config.required_history:
                    continue
                predicted = model.predict_sequence(adc, dac, start=config.required_history)
                comparison = compare_signals(
                    dac,
                    predicted,
                    min_correlation=min_correlation,
                    max_nrmse=max_nrmse,
                    start=config.required_history,
                )
                if best is None or _score(comparison) > _score(best.comparison):
                    best = SearchResult(config=config, comparison=comparison)
    if best is None:
        raise ValueError("no search candidates were provided")
    return best


def _score(result: ComparisonResult) -> tuple[float, float]:
    return (result.correlation, -result.nrmse)


@dataclass
class FilterCapture:
    """Recorded closed-loop signals."""

    adc_channels: list[list[int]]
    dac: list[int] | None = None
    sample_rate: float = 0.0
    metadata: dict[str, object] = field(default_factory=dict)

    def __post_init__(self) -> None:
        if not self.adc_channels:
            raise ValueError("at least one ADC channel is required")
        self.adc_channels = [
            [to_signed16(int(value)) for value in channel]
            for channel in self.adc_channels
        ]
        if self.dac is not None:
            self.dac = [to_signed16(int(value)) for value in self.dac]
        lengths = {len(channel) for channel in self.adc_channels}
        if self.dac is not None:
            lengths.add(len(self.dac))
        if len(lengths) != 1:
            raise ValueError("all capture channels must have the same length")

    @property
    def samples(self) -> int:
        return len(self.adc_channels[0])

    def channel(self, index: int) -> list[int]:
        try:
            return self.adc_channels[index]
        except IndexError as exc:
            raise ValueError(f"capture has no ADC channel {index}") from exc

    def input_output(
        self,
        input_channel: int = 0,
        dac_channel: int = 1,
        *,
        prefer_dac_column: bool = False,
    ) -> tuple[list[int], list[int]]:
        adc = self.channel(input_channel)
        if prefer_dac_column and self.dac is not None:
            return adc, self.dac
        return adc, self.channel(dac_channel)


def _as_int16(value: object) -> int:
    return to_signed16(int(value))


def _load_numpy(path: Path, channels: int | None = None) -> FilterCapture:
    try:
        import numpy as np
    except ImportError as exc:
        raise ImportError(
            "numpy is required to read .npy/.npz captures; install it with "
            "'pip install numpy' or export the data as CSV"
        ) from exc

    if path.suffix.lower() == ".npz":
        with np.load(path) as data:
            keys = set(data.files)
            if "adc" in keys:
                array = data["adc"]
                if array.ndim == 1:
                    array = array.reshape(-1, channels or 1)
                channels_data = [
                    [_as_int16(value) for value in array[:, index]]
                    for index in range(array.shape[1])
                ]
            elif "ch0" in keys:
                channels_data = []
                index = 0
                while f"ch{index}" in keys:
                    channels_data.append(
                        [_as_int16(value) for value in data[f"ch{index}"]]
                    )
                    index += 1
            else:
                raise ValueError(f"{path}: expected an 'adc' or 'ch0' array")
            dac = None
            if "dac" in keys:
                dac = [_as_int16(value) for value in data["dac"]]
            sample_rate = float(data["sample_rate"]) if "sample_rate" in keys else 0.0
            metadata: dict[str, object] = {}
            for key in keys:
                if key in ("adc", "dac", "ch0", "ch1"):
                    continue
                value = data[key]
                if getattr(value, "ndim", 0) == 0:
                    metadata[key] = value.item()
                elif key in ("fir_coefs", "iir_coefs"):
                    metadata[key] = [int(item) for item in value.tolist()]
            return FilterCapture(
                channels_data,
                dac=dac,
                sample_rate=sample_rate,
                metadata=metadata,
            )

    array = np.load(path)
    if array.ndim == 1:
        array = array.reshape(-1, channels or 1)
    channels_data = [
        [_as_int16(value) for value in array[:, index]]
        for index in range(array.shape[1])
    ]
    return FilterCapture(channels_data)


def _delimiter_for(sample: str) -> str:
    if "," in sample:
        return ","
    if ";" in sample:
        return ";"
    if "\t" in sample:
        return "\t"
    return " "


def load_capture(path: str | Path, *, channels: int | None = None) -> FilterCapture:
    """Load a capture from NPY/NPZ or a text table.

    Text tables use one column per ADC channel and an optional column named
    ``dac``.  A header row is detected when the first line contains non-numeric
    fields.  Without a header the first *channels* columns are ADC channels.
    """
    capture_path = Path(path)
    suffix = capture_path.suffix.lower()
    if suffix in (".npy", ".npz"):
        return _load_numpy(capture_path, channels=channels)
    if suffix == ".json":
        payload = json.loads(capture_path.read_text(encoding="utf-8"))
        adc = payload.get("adc")
        if adc is None:
            raise ValueError(f"{capture_path}: JSON capture needs an 'adc' array")
        if adc and not isinstance(adc[0], list):
            adc = [[value] for value in adc]
        dac = payload.get("dac")
        return FilterCapture(
            [[_as_int16(value) for value in column] for column in adc],
            dac=[_as_int16(value) for value in dac] if dac is not None else None,
            sample_rate=float(payload.get("sample_rate", 0.0)),
            metadata={key: value for key, value in payload.items()
                      if key not in ("adc", "dac")},
        )

    text = capture_path.read_text(encoding="utf-8", errors="replace")
    lines = [
        line
        for line in text.splitlines()
        if line.strip() and not line.lstrip().startswith("#")
    ]
    if not lines:
        raise ValueError(f"{capture_path}: empty capture")
    delimiter = _delimiter_for(lines[0])
    rows = list(csv.reader(lines, delimiter=delimiter))
    header: list[str] | None = None
    if not rows[0][0].strip().lstrip("+-").isdigit():
        header = [cell.strip().lower() for cell in rows[0]]
        rows = rows[1:]

    if not rows:
        raise ValueError(f"{capture_path}: no data rows")
    width = len(rows[0])
    if any(len(row) != width for row in rows):
        raise ValueError(f"{capture_path}: inconsistent number of columns")

    dac_index: int | None = None
    if header is not None:
        if "dac" in header:
            dac_index = header.index("dac")
        adc_indices = [index for index, name in enumerate(header)
                       if index != dac_index and name.startswith(("adc", "ch"))]
        if not adc_indices:
            adc_indices = [index for index in range(width) if index != dac_index]
    else:
        channel_count = channels if channels is not None else width
        adc_indices = list(range(min(channel_count, width)))
        dac_index = channel_count if channel_count < width else None

    adc_channels = [
        [_as_int16(row[index]) for row in rows] for index in adc_indices
    ]
    dac = [_as_int16(row[dac_index]) for row in rows] if dac_index is not None else None
    return FilterCapture(adc_channels, dac=dac)


def format_comparison(result: ComparisonResult, config: FilterModelConfig) -> str:
    status = "PASS" if result.passed else "FAIL"
    return "\n".join(
        [
            f"IIR filter model test: {status}",
            (
                f"  config: ntaps={config.ntaps} n2taps={config.n2taps} "
                f"decimation={config.decimation} word={config.word}"
                f"/{config.output_word}"
            ),
            (
                f"  delays: fir={config.fir_delay} iir={config.iir_delay} "
                f"steps=({config.fir_step},{config.iir_step})"
            ),
            f"  samples: {result.samples}",
            f"  correlation: {result.correlation:.6f}",
            f"  RMS error: {result.rmse:.3f} LSB ({result.nrmse:.4%})",
            f"  max abs error: {result.max_abs_error} LSB",
            f"  fitted gain: {result.gain:.6f}  bias: {result.bias:.3f}",
            f"  SNR: {result.snr_db:.2f} dB",
        ]
    )


__all__ = [
    "ACC_MAX",
    "ACC_MIN",
    "ACC_RND",
    "ACC_SHIFT",
    "ComparisonResult",
    "FilterCapture",
    "FilterModel",
    "FilterModelConfig",
    "SearchResult",
    "Word",
    "accumulator_to_word",
    "compare_signals",
    "estimate_bandwidth",
    "format_comparison",
    "load_capture",
    "search_model",
]
