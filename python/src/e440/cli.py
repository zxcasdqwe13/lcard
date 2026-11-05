"""Command line interface: ``python -m e440 {info,acquire,selftest}``."""

from __future__ import annotations

import argparse
import sys
import time
from pathlib import Path
from typing import Sequence

from .backend.base import BackendUnavailable
from .backend.mock import MockBackend
from .device import E440
from .dsp import FIR_TAPS, IIR_TAPS, FilterConfig
from .exceptions import E440Error
from .filter_model import FilterModelConfig, load_capture
from .filter_test import (
    MockLoopConfig,
    analyze_capture,
    auto_analyze,
    format_report,
    make_mock_capture,
    run_mock_test,
    save_report,
)

REPO_ROOT = Path(__file__).resolve().parents[3]
DEFAULT_BIOS = REPO_ROOT / "ADI_DSP" / "E440.BIO"


def _common_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--mock", action="store_true", help="use the simulator")
    parser.add_argument("--dll", metavar="PATH", help="path to Lusbapi64.dll")
    parser.add_argument(
        "--bios",
        metavar="PATH",
        help="LBIOS file; defaults to ADI_DSP/E440.BIO when present",
    )
    parser.add_argument(
        "--no-bios", action="store_true", help="do not load an LBIOS file"
    )
    return parser


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="e440",
        description="LCard E14-440 control and acquisition",
    )
    sub = parser.add_subparsers(dest="command", required=True)

    info = sub.add_parser("info", parents=[_common_parser()], help="show device info")
    info.add_argument("--verbose", action="store_true")

    acquire = sub.add_parser(
        "acquire", parents=[_common_parser()], help="capture ADC samples"
    )
    acquire.add_argument("--blocks", type=int, default=3)
    acquire.add_argument("--rate", type=float, default=200.0, help="ADC rate, kHz")
    acquire.add_argument("--channels", type=int, default=2)
    acquire.add_argument("--inter-kadr-delay", type=float, default=0.01)
    acquire.add_argument(
        "--control-table",
        type=int,
        nargs=2,
        default=(128, 131),
        metavar=("CH0", "CH1"),
        help="first ControlTable entries (MATLAB: [0 3]+2*64)",
    )
    acquire.add_argument("--timeout-ms", type=int, default=3_500_000)
    acquire.add_argument("--buffer-words", type=int, default=256 * 1024)
    acquire.add_argument("--out", type=Path, default=Path("adc.npy"))
    acquire.add_argument(
        "--start-dac",
        action="store_true",
        help="start the DAC before acquisition (closed-loop filter test)",
    )
    acquire.add_argument(
        "--no-filters", action="store_true", help="do not write filter parameters"
    )
    acquire.add_argument("--ntaps", type=int, default=32)
    acquire.add_argument("--n2taps", type=int, default=8)
    acquire.add_argument("--proc-switch", type=int, choices=(1, 2, 3, 4), default=1)
    acquire.add_argument(
        "--decimation",
        type=int,
        default=10,
        help="decimation per channel (word = 0x10000 - decimation*channels)",
    )
    acquire.add_argument("--fir-file", type=Path, help="hex FIR coefficients, one per line")
    acquire.add_argument("--iir-file", type=Path, help="hex IIR coefficients, one per line")

    sub.add_parser("selftest", parents=[_common_parser()], help="run the mock pipeline")

    filter_test = sub.add_parser(
        "filter-test",
        parents=[_common_parser()],
        help="compare the IIR filter model with a closed-loop capture",
    )
    filter_test.add_argument(
        "--capture",
        type=Path,
        help="NPY/NPZ/CSV capture with ADC channels and an optional DAC column",
    )
    filter_test.add_argument("--samples", type=int, default=20_000)
    filter_test.add_argument(
        "--rate-khz",
        type=float,
        help="ADC rate for excitation-bandwidth coverage; defaults to capture metadata",
    )
    filter_test.add_argument("--input-channel", type=int, default=0)
    filter_test.add_argument("--dac-channel", type=int, default=1)
    filter_test.add_argument(
        "--prefer-dac-column",
        action="store_true",
        help="use an explicit 'dac' capture column instead of the ADC feedback channel",
    )
    filter_test.add_argument("--channels", type=int, default=2)
    filter_test.add_argument("--decimation", type=int, default=10)
    filter_test.add_argument("--ntaps", type=int, default=32)
    filter_test.add_argument("--n2taps", type=int, default=8)
    filter_test.add_argument("--fir-file", type=Path, help="hex FIR coefficients")
    filter_test.add_argument("--iir-file", type=Path, help="hex IIR coefficients")
    filter_test.add_argument("--fir-delay", type=int)
    filter_test.add_argument("--iir-delay", type=int)
    filter_test.add_argument("--fir-step", type=int)
    filter_test.add_argument("--iir-step", type=int)
    filter_test.add_argument(
        "--input-delay",
        type=int,
        default=0,
        help="current-input delay in frames (transport delay of the analog loop)",
    )
    filter_test.add_argument(
        "--word",
        choices=("mr1", "mr0"),
        help="accumulator word stored in the feedback history (default mr1)",
    )
    filter_test.add_argument(
        "--output-word",
        choices=("mr1", "mr0"),
        help="observable output word; defaults to --word",
    )
    filter_test.add_argument(
        "--invert-output",
        action="store_true",
        help="invert the loopback output channel before comparison "
        "(anti-phase analog loopback)",
    )
    filter_test.add_argument(
        "--free-run",
        action="store_true",
        help="use the model's own feedback history instead of the recorded one",
    )
    filter_test.add_argument(
        "--auto",
        action="store_true",
        help="try MR1/MR0 and one-step/free-run paths and report the best match",
    )
    filter_test.add_argument(
        "--search",
        action="store_true",
        help="search delays and both accumulator words for the best match",
    )
    filter_test.add_argument("--dac-gain", type=float, default=1.0)
    filter_test.add_argument("--loop-gain", type=float, default=1.0)
    filter_test.add_argument("--bias", type=float, default=0.0)
    filter_test.add_argument("--analog-noise", type=int, default=0)
    filter_test.add_argument("--refine-scale", type=int, default=0)
    filter_test.add_argument("--seed", type=int, default=0xE440)
    filter_test.add_argument("--min-correlation", type=float, default=0.95)
    filter_test.add_argument("--max-nrmse", type=float, default=0.10)
    filter_test.add_argument(
        "--no-capture-metadata",
        action="store_true",
        help="ignore filter parameters stored in an NPZ capture",
    )
    filter_test.add_argument("--out-json", type=Path)

    filter_capture = sub.add_parser(
        "filter-capture",
        parents=[_common_parser()],
        help="capture a closed-loop record for filter-test",
    )
    filter_capture.add_argument("--blocks", type=int, default=20)
    filter_capture.add_argument("--samples", type=int, default=20_000)
    filter_capture.add_argument("--analog-noise", type=int, default=0)
    filter_capture.add_argument("--seed", type=int, default=0xE440)
    filter_capture.add_argument("--rate", type=float, default=200.0, help="ADC rate, kHz")
    filter_capture.add_argument("--channels", type=int, default=2)
    filter_capture.add_argument("--inter-kadr-delay", type=float, default=0.01)
    filter_capture.add_argument(
        "--control-table",
        type=int,
        nargs=2,
        default=(128, 131),
        metavar=("CH0", "CH1"),
    )
    filter_capture.add_argument("--timeout-ms", type=int, default=3_500_000)
    filter_capture.add_argument("--buffer-words", type=int, default=256 * 1024)
    filter_capture.add_argument("--ntaps", type=int, default=32)
    filter_capture.add_argument("--n2taps", type=int, default=8)
    filter_capture.add_argument("--proc-switch", type=int, choices=(1, 2, 3, 4), default=1)
    filter_capture.add_argument("--decimation", type=int, default=10)
    filter_capture.add_argument("--fir-file", type=Path)
    filter_capture.add_argument("--iir-file", type=Path)
    filter_capture.add_argument("--start-dac", action="store_true")
    filter_capture.add_argument("--out", type=Path, default=Path("filter_capture.npz"))
    return parser


def _open_device(args: argparse.Namespace) -> E440:
    if args.mock:
        device = E440.open(backend=MockBackend())
    else:
        from .backend.windows import WindowsBackend

        device = E440.open(backend=WindowsBackend(dll_path=args.dll))

    if args.no_bios:
        return device

    bios = Path(args.bios) if args.bios else DEFAULT_BIOS
    if bios.is_file():
        device.load_bios(str(bios))
        print(f"LBIOS: {bios}")
    elif args.bios:
        device.close()
        raise FileNotFoundError(f"BIOS file not found: {bios}")
    return device


def _prepare_dac(device: E440) -> None:
    """Initialize the DAC FIFO pointers and leave TX0 driving the loopback.

    ``InitDacPointers`` runs only in START_DAC, so a plain STOP_DAC leaves the
    IIR history pointer (I1/L1) uninitialized.  Starting and immediately
    stopping the DAC initializes the pointers while the autobuffer stays off,
    so the ADC interrupt's TX0 writes define the loopback signal.
    """
    try:
        device.start_dac()
        device.stop_dac()
    except E440Error:
        try:
            device.stop_dac()
        except E440Error:
            pass


def _read_hex_coefs(path: Path, size: int, *, default: int = 0) -> list[int]:
    values: list[int] = []
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = line.split("#", 1)[0].split("%", 1)[0].strip()
        if not line:
            continue
        for token in line.replace(",", " ").split():
            values.append(int(token, 16) & 0xFFFF)
    if len(values) > size:
        raise ValueError(f"{path}: expected at most {size} coefficients, got {len(values)}")
    values.extend([default] * (size - len(values)))
    return values


def _filter_config(args: argparse.Namespace) -> FilterConfig:
    if args.fir_file:
        fir = _read_hex_coefs(args.fir_file, FIR_TAPS)
    else:
        fir = [0] * FIR_TAPS
        fir[0] = 0x8000
    if args.iir_file:
        iir = _read_hex_coefs(args.iir_file, IIR_TAPS)
    else:
        iir = [0] * IIR_TAPS
    return FilterConfig(
        ntaps=args.ntaps,
        n2taps=getattr(args, "n2taps", 8),
        fir_coef1=fir,
        iir_coefs=iir,
        decimation=args.decimation,
        channels=args.channels,
        proc_switch=getattr(args, "proc_switch", 1),
    )


def _normalize_coefs(values, size: int) -> list[int]:
    result = [int(value) & 0xFFFF for value in list(values)[:size]]
    result.extend([0] * (size - len(result)))
    return result


def _filter_model_config(
    args: argparse.Namespace,
    *,
    fir_coefs=None,
    iir_coefs=None,
    ntaps: int | None = None,
    n2taps: int | None = None,
    decimation: int | None = None,
    fir_delay: int | None = None,
    iir_delay: int | None = None,
    fir_step: int | None = None,
    iir_step: int | None = None,
    input_delay: int | None = None,
) -> FilterModelConfig:
    if args.fir_file:
        fir = _read_hex_coefs(args.fir_file, FIR_TAPS)
    elif fir_coefs is not None:
        fir = _normalize_coefs(fir_coefs, FIR_TAPS)
    else:
        fir = [0] * FIR_TAPS
        fir[0] = 0x8000
    if args.iir_file:
        iir = _read_hex_coefs(args.iir_file, IIR_TAPS)
    elif iir_coefs is not None:
        iir = _normalize_coefs(iir_coefs, IIR_TAPS)
    else:
        iir = [0] * IIR_TAPS
        if getattr(args, "mock", False):
            # Exercise the feedback path in the built-in demo; real captures
            # should always provide the coefficients actually written to DSP.
            iir[0] = 0x1000
    kwargs: dict[str, object] = {
        "ntaps": args.ntaps if ntaps is None else int(ntaps),
        "n2taps": args.n2taps if n2taps is None else int(n2taps),
        "decimation": args.decimation if decimation is None else int(decimation),
        "channels": args.channels,
        "fir_coefs": fir,
        "iir_coefs": iir,
    }
    arg_fir_delay = getattr(args, "fir_delay", None)
    arg_iir_delay = getattr(args, "iir_delay", None)
    arg_fir_step = getattr(args, "fir_step", None)
    arg_iir_step = getattr(args, "iir_step", None)
    if arg_fir_delay is not None:
        kwargs["fir_delay"] = arg_fir_delay
    elif fir_delay is not None:
        kwargs["fir_delay"] = int(fir_delay)
    if arg_iir_delay is not None:
        kwargs["iir_delay"] = arg_iir_delay
    elif iir_delay is not None:
        kwargs["iir_delay"] = int(iir_delay)
    if arg_fir_step is not None:
        kwargs["fir_step"] = arg_fir_step
    elif fir_step is not None:
        kwargs["fir_step"] = int(fir_step)
    if arg_iir_step is not None:
        kwargs["iir_step"] = arg_iir_step
    elif iir_step is not None:
        kwargs["iir_step"] = int(iir_step)
    arg_input_delay = getattr(args, "input_delay", None)
    if arg_input_delay is not None:
        kwargs["input_delay"] = int(arg_input_delay)
    elif input_delay is not None:
        kwargs["input_delay"] = int(input_delay)
    arg_word = getattr(args, "word", None)
    arg_output_word = getattr(args, "output_word", None)
    if arg_word is not None:
        kwargs["word"] = arg_word
    if arg_output_word is not None:
        kwargs["output_word"] = arg_output_word
    return FilterModelConfig(**kwargs)  # type: ignore[arg-type]


def _stats(samples, channels: int) -> Sequence[str]:
    try:
        import numpy as np
    except ImportError:
        return [
            f"channel {index}: min={min(samples[index::channels])} "
            f"max={max(samples[index::channels])}"
            for index in range(channels)
        ]

    data = np.frombuffer(samples.tobytes(), dtype=np.int16)
    frames = data[: len(data) // channels * channels].reshape(-1, channels)
    lines = []
    for index in range(channels):
        column = frames[:, index].astype(np.float64)
        rms = float(np.sqrt(np.mean(column * column)))
        lines.append(
            f"channel {index}: min={column.min():.0f} max={column.max():.0f} "
            f"mean={column.mean():.1f} rms={rms:.1f}"
        )
    return lines


def _save(samples, path: Path) -> Path:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.suffix.lower() == ".npy":
        try:
            import numpy as np
        except ImportError:
            path = path.with_suffix(".bin")
            path.write_bytes(samples.tobytes())
            print("numpy is not installed; raw int16 written instead")
            return path
        np.save(path, np.frombuffer(samples.tobytes(), dtype=np.int16))
        return path
    path.write_bytes(samples.tobytes())
    return path


def cmd_info(args: argparse.Namespace) -> int:
    with _open_device(args) as device:
        description = device.description
        print(description.summary())
        if args.verbose:
            print(f"  revision:   {description.revision}.{description.modification}")
            print(f"  comment:    {description.comment}")
            print(f"  DSP clock:  {description.dsp_clock_rate / 1e6:.3f} MHz")
            print(f"  DSP ver:    {description.dsp_version}")
            print(f"  MCU:        {description.mcu_name} {description.mcu_version}")
            print(f"  interface:  {description.interface_name}")
            print(f"  digital IO: {description.digital_io_name}")
        params = device.get_adc_params()
        print(
            f"ADC: rate={params.adc_rate:g} kHz channels={params.channels} "
            f"inter_kadr_delay={params.inter_kadr_delay:g} ms"
        )
        print(f"ControlTable[0:4]={params.control_table[:4]}")
        try:
            print(
                f"PM[NTaps]=0x{device.read_pm_word(0x7B):04X} "
                f"PM[Decim]=0x{device.read_pm_word(0x7F):04X}"
            )
        except E440Error:
            pass
    return 0


def cmd_acquire(args: argparse.Namespace) -> int:
    with _open_device(args) as device:
        device.test_module()
        _prepare_dac(device)
        actual = device.configure_adc(
            rate=args.rate,
            channels=args.channels,
            inter_kadr_delay=args.inter_kadr_delay,
            control_table=args.control_table,
        )
        if not args.no_filters:
            device.apply_filters(_filter_config(args))
            print(
                f"filters: ntaps={args.ntaps} decimation={args.decimation} "
                f"channels={args.channels}"
            )
        print(
            f"ADC: rate={actual.adc_rate:g} kHz channels={actual.channels}; "
            f"capturing {args.blocks} block(s) x {args.buffer_words} words"
        )
        if args.start_dac:
            device.start_dac()
        started = time.monotonic()
        try:
            samples = device.acquire_all(
                args.blocks,
                timeout_ms=args.timeout_ms,
                buffer_words=args.buffer_words,
            )
        finally:
            if args.start_dac:
                try:
                    device.stop_dac()
                except Exception:
                    pass
        elapsed = time.monotonic() - started
        out = _save(samples, args.out)
        print(f"saved {len(samples)} samples to {out} in {elapsed:.2f} s")
        for line in _stats(samples, max(1, actual.channels)):
            print(line)
    return 0


def cmd_selftest(args: argparse.Namespace) -> int:
    args.mock = True
    with _open_device(args) as device:
        device.test_module()
        device.configure_adc(rate=200.0, channels=2, control_table=(128, 131))
        device.apply_filters(FilterConfig(decimation=10, channels=2))
        samples = device.acquire_all(2, buffer_words=4096)
        if not samples:
            raise E440Error("mock acquisition returned no samples")
        print(f"selftest OK: {len(samples)} samples, min={min(samples)} max={max(samples)}")
        ntaps = device.read_pm_word(0x7B)
        decim = device.read_pm_word(0x7F)
        print(f"PM[NTaps]=0x{ntaps:04X} PM[Decim]=0x{decim:04X}")
    return 0


def _save_capture(
    samples,
    channels: int,
    path: Path,
    metadata: dict[str, object],
) -> Path:
    """Write interleaved ADC samples as NPZ (or CSV without numpy)."""
    frames = len(samples) // max(1, channels)
    try:
        import numpy as np

        data = np.frombuffer(samples.tobytes(), dtype=np.int16)
        data = data[: frames * channels].reshape(-1, channels)
        np.savez(path, adc=data, **metadata)
        return path
    except ImportError:
        path = path.with_suffix(".csv")
        with path.open("w", encoding="utf-8") as handle:
            header = ",".join(f"adc{index}" for index in range(channels))
            handle.write(header + "\n")
            for frame in range(frames):
                start = frame * channels
                values = (str(samples[start + index]) for index in range(channels))
                handle.write(",".join(values) + "\n")
        return path


def _save_filter_capture(
    capture,
    path: Path,
    metadata: dict[str, object],
) -> Path:
    """Write per-channel filter-test data as NPZ (or CSV without numpy)."""
    channels = len(capture.adc_channels)
    try:
        import numpy as np

        adc = np.array(capture.adc_channels, dtype=np.int16).T
        np.savez(path, adc=adc, **metadata)
        return path
    except ImportError:
        path = path.with_suffix(".csv")
        with path.open("w", encoding="utf-8") as handle:
            header = ",".join(f"adc{index}" for index in range(channels))
            handle.write(header + "\n")
            for row in zip(*capture.adc_channels):
                handle.write(",".join(str(value) for value in row) + "\n")
        return path


def _filter_capture_metadata(
    filters: FilterConfig,
    channels: int,
    *,
    rate_khz: float = 0.0,
) -> dict[str, object]:
    return {
        "rate_khz": rate_khz,
        "channels": channels,
        "ntaps": filters.ntaps,
        "n2taps": filters.n2taps,
        "decimation": filters.decimation,
        "proc_switch": filters.proc_switch,
        "fir_delay": filters.decimation,
        "fir_step": filters.decimation,
        "iir_delay": max(1, 2 // max(1, channels)),
        "iir_step": filters.decimation,
        "fir_coefs": list(filters.fir_coef1),
        "iir_coefs": list(filters.iir_coefs),
    }


def cmd_filter_capture(args: argparse.Namespace) -> int:
    if args.mock:
        model_config = _filter_model_config(args)
        capture = make_mock_capture(
            model_config,
            MockLoopConfig(
                samples=args.samples,
                analog_noise=args.analog_noise,
                seed=args.seed,
            ),
        )
        metadata = {
            "rate_khz": args.rate,
            "channels": len(capture.adc_channels),
            "ntaps": model_config.ntaps,
            "n2taps": model_config.n2taps,
            "decimation": model_config.decimation,
            "fir_delay": model_config.fir_delay,
            "fir_step": model_config.fir_step,
            "iir_delay": model_config.iir_delay,
            "iir_step": model_config.iir_step,
            "fir_coefs": list(model_config.fir_coefs),
            "iir_coefs": list(model_config.iir_coefs),
        }
        output = _save_filter_capture(capture, args.out, metadata)
        print(
            f"capture: {output} ({capture.samples} frames, "
            f"{len(capture.adc_channels)} channels)"
        )
        print(
            "next: python -m e440 filter-test --capture "
            f"{output} --channels {len(capture.adc_channels)} --auto"
        )
        return 0

    with _open_device(args) as device:
        device.test_module()
        _prepare_dac(device)
        actual = device.configure_adc(
            rate=args.rate,
            channels=args.channels,
            inter_kadr_delay=args.inter_kadr_delay,
            control_table=args.control_table,
        )
        filters = _filter_config(args)
        device.apply_filters(filters)
        if args.start_dac:
            device.start_dac()
        try:
            samples = device.acquire_all(
                args.blocks,
                timeout_ms=args.timeout_ms,
                buffer_words=args.buffer_words,
            )
        finally:
            if args.start_dac:
                try:
                    device.stop_dac()
                except Exception:
                    pass

    if not samples:
        raise E440Error("filter capture returned no samples")
    channels = max(1, actual.channels)
    metadata = _filter_capture_metadata(
        filters, channels, rate_khz=float(actual.adc_rate)
    )
    output = _save_capture(samples, channels, args.out, metadata)
    print(f"capture: {output} ({len(samples)} words, {channels} channels)")
    next_command = (
        "python -m e440 filter-test --capture "
        f"{output} --channels {channels} --ntaps {args.ntaps} "
        f"--n2taps {args.n2taps} --decimation {args.decimation}"
    )
    if args.fir_file:
        next_command += f' --fir-file "{args.fir_file}"'
    if args.iir_file:
        next_command += f' --iir-file "{args.iir_file}"'
    next_command += " --auto"
    print("next: " + next_command)
    return 0


def _search_ranges(
    args: argparse.Namespace, config: FilterModelConfig
) -> tuple[list[int] | None, list[int] | None, list[str]]:
    if not args.search:
        words = [args.word] if args.word else [config.word]
        return None, None, words
    if args.fir_delay is None:
        fir_delays = list(range(max(0, config.decimation - 1), config.decimation + 3))
    else:
        fir_delays = [args.fir_delay]
    if args.iir_delay is None:
        iir_delays = list(range(1, 4))
    else:
        iir_delays = [args.iir_delay]
    words = [args.word] if args.word else ["mr1", "mr0"]
    return fir_delays, iir_delays, words


def _invert_capture_output(capture, dac_channel: int, prefer_dac_column: bool) -> None:
    """Negate the recorded loopback output for an anti-phase analog loop."""
    if prefer_dac_column and capture.dac is not None:
        capture.dac = [-value for value in capture.dac]
        return
    if not 0 <= dac_channel < len(capture.adc_channels):
        raise ValueError(
            f"dac channel {dac_channel} is out of range for a capture "
            f"with {len(capture.adc_channels)} ADC channel(s)"
        )
    channel = capture.adc_channels[dac_channel]
    capture.adc_channels[dac_channel] = [-value for value in channel]


def cmd_filter_test(args: argparse.Namespace) -> int:
    if args.mock and args.capture:
        raise ValueError("choose either --mock or --capture")
    if not args.mock and not args.capture:
        raise ValueError("specify --mock or --capture")
    if args.auto and args.search:
        raise ValueError("--auto and --search are mutually exclusive")

    capture = None
    if args.mock:
        config = _filter_model_config(args)
    else:
        capture = load_capture(args.capture, channels=args.channels)
        if args.invert_output:
            _invert_capture_output(
                capture, args.dac_channel, args.prefer_dac_column
            )
        metadata = {} if args.no_capture_metadata else capture.metadata
        rate_khz = args.rate_khz
        if rate_khz is None:
            rate_khz = metadata.get("rate_khz")
        config = _filter_model_config(
            args,
            fir_coefs=metadata.get("fir_coefs"),
            iir_coefs=metadata.get("iir_coefs"),
            ntaps=metadata.get("ntaps"),
            n2taps=metadata.get("n2taps"),
            decimation=metadata.get("decimation"),
            fir_delay=metadata.get("fir_delay"),
            iir_delay=metadata.get("iir_delay"),
            fir_step=metadata.get("fir_step"),
            iir_step=metadata.get("iir_step"),
        )
    fir_delays, iir_delays, words = _search_ranges(args, config)
    common = {
        "search": args.search,
        "free_run": args.free_run,
        "fir_delays": fir_delays,
        "iir_delays": iir_delays,
        "words": words,
        "min_correlation": args.min_correlation,
        "max_nrmse": args.max_nrmse,
    }
    auto_common = {
        "history_scale": args.dac_gain * args.loop_gain,
        "history_offset": args.bias,
        "refine_scale": args.refine_scale,
        "min_correlation": args.min_correlation,
        "max_nrmse": args.max_nrmse,
    }

    if args.mock:
        loop = MockLoopConfig(
            samples=args.samples,
            dac_gain=args.dac_gain,
            loop_gain=args.loop_gain,
            bias=args.bias,
            analog_noise=args.analog_noise,
            seed=args.seed,
            rate_khz=args.rate_khz or 200.0,
        )
        if args.auto:
            capture = make_mock_capture(config, loop)
            auto_common["history_scale"] = loop.dac_gain * loop.loop_gain
            auto_common["history_offset"] = loop.bias
            auto_common["rate_hz"] = loop.rate_khz * 1e3
            result = auto_analyze(
                capture,
                config,
                prefer_dac_column=args.prefer_dac_column,
                **auto_common,
            )
        else:
            result = run_mock_test(config, loop, **common)
    else:
        assert capture is not None
        if args.auto:
            result = auto_analyze(
                capture,
                config,
                input_channel=args.input_channel,
                dac_channel=args.dac_channel,
                prefer_dac_column=args.prefer_dac_column,
                rate_hz=float(rate_khz) * 1e3 if rate_khz else None,
                **auto_common,
            )
        else:
            result = analyze_capture(
                capture,
                config,
                input_channel=args.input_channel,
                dac_channel=args.dac_channel,
                prefer_dac_column=args.prefer_dac_column,
                history_scale=args.dac_gain * args.loop_gain,
                history_offset=args.bias,
                refine_scale=args.refine_scale,
                rate_hz=float(rate_khz) * 1e3 if rate_khz else None,
                **common,
            )

    print(format_report(result))
    if args.out_json:
        saved = save_report(result, args.out_json)
        print(f"report: {saved}")
    return 0 if result.comparison.passed else 1


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    commands = {
        "info": cmd_info,
        "acquire": cmd_acquire,
        "selftest": cmd_selftest,
        "filter-test": cmd_filter_test,
        "filter-capture": cmd_filter_capture,
    }
    try:
        return commands[args.command](args)
    except (E440Error, BackendUnavailable, FileNotFoundError, ValueError, OSError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(main())
