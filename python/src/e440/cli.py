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
    acquire.add_argument("--inter-kadr-delay", type=float, default=0.002)
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
        "--no-filters", action="store_true", help="do not write filter parameters"
    )
    acquire.add_argument("--ntaps", type=int, default=32)
    acquire.add_argument(
        "--decimation",
        type=int,
        default=10,
        help="decimation per channel (word = 0x10000 - decimation*channels)",
    )
    acquire.add_argument("--fir-file", type=Path, help="hex FIR coefficients, one per line")
    acquire.add_argument("--iir-file", type=Path, help="hex IIR coefficients, one per line")

    sub.add_parser("selftest", parents=[_common_parser()], help="run the mock pipeline")
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
        fir_coef1=fir,
        iir_coefs=iir,
        decimation=args.decimation,
        channels=args.channels,
    )


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
        started = time.monotonic()
        samples = device.acquire_all(
            args.blocks,
            timeout_ms=args.timeout_ms,
            buffer_words=args.buffer_words,
        )
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


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    commands = {
        "info": cmd_info,
        "acquire": cmd_acquire,
        "selftest": cmd_selftest,
    }
    try:
        return commands[args.command](args)
    except (E440Error, BackendUnavailable, FileNotFoundError, ValueError, OSError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(main())
