"""Closed-loop filter tests: synthetic mock and captured ADC data."""

from __future__ import annotations

import json
import math
import random
from dataclasses import dataclass, field
from pathlib import Path
from typing import Iterable, Sequence

from .filter_model import (
    ComparisonResult,
    FilterCapture,
    FilterModel,
    FilterModelConfig,
    SearchResult,
    Word,
    compare_signals,
    estimate_bandwidth,
    format_comparison,
    search_model,
)

CLIP_MIN = -32768
CLIP_MAX = 32767


@dataclass
class MockLoopConfig:
    """Parameters of the synthetic DAC -> ADC feedback path."""

    samples: int = 20_000
    noise_amplitude: int = 12_000
    rate_khz: float = 200.0
    dac_gain: float = 1.0
    loop_gain: float = 1.0
    bias: float = 0.0
    analog_noise: int = 0
    seed: int = 0xE440


@dataclass
class FilterTestResult:
    config: FilterModelConfig
    comparison: ComparisonResult
    history_scale: float = 1.0
    mode: str = "one_step"
    input_bandwidth_hz: float | None = None
    decimated_nyquist_hz: float | None = None
    adc_nyquist_hz: float | None = None
    coverage: str = ""
    predicted: list[int] = field(repr=False, default_factory=list)
    capture: FilterCapture | None = field(repr=False, default=None)
    candidates: list["FilterTestResult"] = field(repr=False, default_factory=list)

    def as_dict(self) -> dict[str, object]:
        payload = self.comparison.as_dict()
        payload.update(
            {
                "history_scale": self.history_scale,
                "mode": self.mode,
                "input_bandwidth_hz": self.input_bandwidth_hz,
                "decimated_nyquist_hz": self.decimated_nyquist_hz,
                "adc_nyquist_hz": self.adc_nyquist_hz,
                "coverage": self.coverage,
                "ntaps": self.config.ntaps,
                "n2taps": self.config.n2taps,
                "decimation": self.config.decimation,
                "word": self.config.word,
                "output_word": self.config.output_word,
                "fir_delay": self.config.fir_delay,
                "iir_delay": self.config.iir_delay,
                "fir_step": self.config.fir_step,
                "iir_step": self.config.iir_step,
                "candidates": [
                    {
                        "word": candidate.config.word,
                        "output_word": candidate.config.output_word,
                        "mode": candidate.mode,
                        "correlation": candidate.comparison.correlation,
                        "nrmse": (
                            candidate.comparison.nrmse
                            if math.isfinite(candidate.comparison.nrmse)
                            else None
                        ),
                    }
                    for candidate in self.candidates
                ],
            }
        )
        return payload


def _clip(value: int) -> int:
    return max(CLIP_MIN, min(CLIP_MAX, value))


def make_mock_capture(
    config: FilterModelConfig,
    loop: MockLoopConfig | None = None,
) -> FilterCapture:
    """Generate a synthetic closed-loop capture with white noise excitation."""
    settings = loop or MockLoopConfig()
    if settings.samples <= config.required_history:
        raise ValueError("samples must exceed the filter history length")
    rng = random.Random(settings.seed)
    noise = [
        _clip(round(rng.uniform(-settings.noise_amplitude, settings.noise_amplitude)))
        for _ in range(settings.samples)
    ]
    model = FilterModel(config)
    filtered = model.simulate(noise)
    dac = [
        _clip(round(value * settings.dac_gain))
        for value in filtered
    ]
    feedback = []
    for value in dac:
        sample = value * settings.loop_gain + settings.bias
        if settings.analog_noise:
            sample += rng.uniform(-settings.analog_noise, settings.analog_noise)
        feedback.append(_clip(round(sample)))
    return FilterCapture([noise, feedback], dac=dac)


def _normalize(values: Sequence[int], scale: float, offset: float) -> list[int]:
    if scale == 0.0:
        raise ValueError("history scale must be non-zero")
    return [_clip(round((value - offset) / scale)) for value in values]


def analyze_capture(
    capture: FilterCapture,
    config: FilterModelConfig,
    *,
    input_channel: int = 0,
    dac_channel: int = 1,
    prefer_dac_column: bool = False,
    history_scale: float = 1.0,
    history_offset: float = 0.0,
    refine_scale: int = 0,
    search: bool = False,
    free_run: bool = False,
    fir_delays: Iterable[int] | None = None,
    iir_delays: Iterable[int] | None = None,
    words: Iterable[Word] = ("mr1", "mr0"),
    min_correlation: float = 0.95,
    max_nrmse: float = 0.10,
    rate_hz: float | None = None,
) -> FilterTestResult:
    """Compare a capture with the fixed-point filter model.

    ``history_scale`` converts the recorded feedback channel into filter
    units.  If ``refine_scale`` is positive, the scale is refined from the
    fitted gain, which is useful when the DAC/ADC loop gain is unknown.
    """
    adc, dac = capture.input_output(
        input_channel,
        dac_channel,
        prefer_dac_column=prefer_dac_column,
    )
    if len(adc) != len(dac):
        raise ValueError("input and feedback channels have different lengths")
    if len(adc) <= config.required_history:
        raise ValueError(
            f"capture has {len(adc)} samples, need more than "
            f"{config.required_history} for the filter history"
        )

    mixed_words = config.word != config.output_word
    use_free_run = free_run or mixed_words
    if search and use_free_run:
        raise ValueError(
            "search is only supported for one-step prediction with matching "
            "history/output words"
        )

    scale = history_scale
    best: SearchResult | None = None
    predicted: list[int] = []
    for attempt in range(refine_scale + 1):
        normalized = _normalize(dac, scale, history_offset)
        if search:
            best = search_model(
                adc,
                normalized,
                config,
                fir_delays=fir_delays,
                iir_delays=iir_delays,
                words=words,
                min_correlation=min_correlation,
                max_nrmse=max_nrmse,
            )
            active_config = best.config
            comparison = best.comparison
            predicted = FilterModel(active_config).predict_sequence(
                adc, normalized, start=active_config.required_history
            )
        else:
            active_config = config
            model = FilterModel(active_config)
            if use_free_run:
                predicted = model.simulate(adc)
            else:
                predicted = model.predict_sequence(adc, normalized)
            comparison = compare_signals(
                normalized,
                predicted,
                min_correlation=min_correlation,
                max_nrmse=max_nrmse,
                start=active_config.required_history,
            )
        if attempt >= refine_scale:
            break
        if comparison.gain == 0.0 or not math.isfinite(comparison.gain):
            break
        new_scale = scale * comparison.gain
        if abs(new_scale - scale) <= abs(scale) * 1e-6:
            scale = new_scale
            break
        scale = new_scale

    if best is not None:
        active_config = best.config

    input_bandwidth_hz: float | None = None
    decimated_nyquist_hz: float | None = None
    adc_nyquist_hz: float | None = None
    coverage = ""
    if rate_hz is not None and rate_hz > 0:
        per_channel_rate = rate_hz / max(1, active_config.channels)
        input_bandwidth_hz = estimate_bandwidth(adc, per_channel_rate)
        decimated_nyquist_hz = per_channel_rate / active_config.decimation / 2.0
        adc_nyquist_hz = per_channel_rate / 2.0
        if input_bandwidth_hz is None:
            coverage = "unknown (numpy unavailable or constant input)"
        elif input_bandwidth_hz < 0.95 * decimated_nyquist_hz:
            coverage = "lowpass: excitation does not cover the decimated band"
        elif input_bandwidth_hz < 0.5 * adc_nyquist_hz:
            coverage = (
                "partial: decimated band covered; resonances above "
                f"{input_bandwidth_hz / 1e3:.1f} kHz may be invisible"
            )
        else:
            coverage = "broadband"

    return FilterTestResult(
        config=active_config,
        comparison=comparison,
        history_scale=scale,
        mode="free_run" if use_free_run else "one_step",
        input_bandwidth_hz=input_bandwidth_hz,
        decimated_nyquist_hz=decimated_nyquist_hz,
        adc_nyquist_hz=adc_nyquist_hz,
        coverage=coverage,
        predicted=predicted,
        capture=capture,
    )


def auto_analyze(
    capture: FilterCapture,
    config: FilterModelConfig,
    *,
    input_channel: int = 0,
    dac_channel: int = 1,
    prefer_dac_column: bool = False,
    history_scale: float = 1.0,
    history_offset: float = 0.0,
    refine_scale: int = 0,
    min_correlation: float = 0.95,
    max_nrmse: float = 0.10,
    rate_hz: float | None = None,
) -> FilterTestResult:
    """Try the plausible firmware paths and return the best match.

    The candidates are ``MR1``/``MR1`` and ``MR0``/``MR0`` one-step models
    plus free-running ``MR0`` history / ``MR1`` output (the current
    ``ADC-fir.H`` path) and ``MR1``/``MR1``.
    """
    candidates: list[FilterTestResult] = []
    combinations = (
        ("mr1", "mr1", False),
        ("mr0", "mr0", False),
        ("mr0", "mr1", True),
        ("mr1", "mr1", True),
    )
    seen: set[tuple[str, str, bool]] = set()
    for word, output_word, free_run in combinations:
        key = (word, output_word, free_run)
        if key in seen:
            continue
        seen.add(key)
        candidate_config = config.with_delays(
            word=word, output_word=output_word
        )
        candidates.append(
            analyze_capture(
                capture,
                candidate_config,
                input_channel=input_channel,
                dac_channel=dac_channel,
                prefer_dac_column=prefer_dac_column,
                history_scale=history_scale,
                history_offset=history_offset,
                refine_scale=refine_scale,
                free_run=free_run,
                min_correlation=min_correlation,
                max_nrmse=max_nrmse,
                rate_hz=rate_hz,
            )
        )
    best = max(
        candidates,
        key=lambda result: (result.comparison.correlation, -result.comparison.nrmse),
    )
    best.candidates = candidates
    return best


def run_mock_test(
    config: FilterModelConfig,
    loop: MockLoopConfig | None = None,
    *,
    search: bool = False,
    free_run: bool = False,
    fir_delays: Iterable[int] | None = None,
    iir_delays: Iterable[int] | None = None,
    words: Iterable[Word] = ("mr1", "mr0"),
    min_correlation: float = 0.95,
    max_nrmse: float = 0.10,
) -> FilterTestResult:
    """Run the model against a synthetic closed-loop device."""
    settings = loop or MockLoopConfig()
    capture = make_mock_capture(config, settings)
    scale = settings.dac_gain * settings.loop_gain
    return analyze_capture(
        capture,
        config,
        history_scale=scale,
        history_offset=settings.bias,
        search=search,
        free_run=free_run,
        fir_delays=fir_delays,
        iir_delays=iir_delays,
        words=words,
        min_correlation=min_correlation,
        max_nrmse=max_nrmse,
        rate_hz=settings.rate_khz * 1e3,
    )


def format_report(result: FilterTestResult) -> str:
    lines = [format_comparison(result.comparison, result.config)]
    lines.append(f"  mode: {result.mode}")
    lines.append(f"  history scale: {result.history_scale:.6f}")
    if result.input_bandwidth_hz is not None:
        lines.append(f"  input bandwidth (99%): {result.input_bandwidth_hz / 1e3:.2f} kHz")
        if result.decimated_nyquist_hz is not None:
            lines.append(
                f"  decimated Nyquist: {result.decimated_nyquist_hz / 1e3:.2f} kHz"
            )
        if result.adc_nyquist_hz is not None:
            lines.append(f"  ADC Nyquist/channel: {result.adc_nyquist_hz / 1e3:.2f} kHz")
        if result.coverage:
            lines.append(f"  excitation: {result.coverage}")
    if result.candidates:
        lines.append("  candidates:")
        for candidate in result.candidates:
            lines.append(
                f"    {candidate.config.word}/{candidate.config.output_word} "
                f"{candidate.mode}: corr={candidate.comparison.correlation:.6f} "
                f"nrmse={candidate.comparison.nrmse:.4%}"
            )
    return "\n".join(lines)


def save_report(result: FilterTestResult, path: str | Path) -> Path:
    output = Path(path)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(
        json.dumps(result.as_dict(), indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    return output


__all__ = [
    "FilterTestResult",
    "MockLoopConfig",
    "analyze_capture",
    "auto_analyze",
    "format_report",
    "make_mock_capture",
    "run_mock_test",
    "save_report",
]
