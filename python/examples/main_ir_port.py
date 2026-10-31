#!/usr/bin/env python3
"""Port of ``main_ir.m`` on top of the :mod:`e440` package.

Run with hardware on Windows:

    python python/examples/main_ir_port.py --bios ADI_DSP/E440.bio

Or without hardware:

    python python/examples/main_ir_port.py --mock
"""

from __future__ import annotations

import argparse
from pathlib import Path

from e440 import E440, FilterConfig, MockBackend
from e440.dsp import FIR_TAPS, IIR_TAPS

# Values from main_ir.m.
BASE_ADDR = 0x30
FIR_NTAPS = 32
DAC_AMP = 0xFFFF
SHIFT = 0xFFFF
PROC_SWITCH = 1
DECIM_USER = 10
ADC_RATE = 200.0
N_CHANNELS = 2
CONTROL_TABLE = [0, 3] + [2] * 64 + [0] * 32
N_LOOP = 30
TIME_WAIT_MS = 3_500_000
BUFFER_WORDS = 256 * 1024

REPO_ROOT = Path(__file__).resolve().parents[2]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--mock", action="store_true", help="use the simulator")
    parser.add_argument("--bios", type=Path, default=REPO_ROOT / "ADI_DSP/E440.BIO")
    parser.add_argument("--blocks", type=int, default=N_LOOP)
    parser.add_argument("--out", type=Path, default=Path("main_ir_data.npy"))
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    if args.mock:
        device = E440.open(backend=MockBackend())
    else:
        device = E440.open()

    with device:
        device.load_bios(str(args.bios))
        device.test_module()
        description = device.description
        print(f"Модуль: {description.company_name} {description.device_name}")

        device.configure_adc(
            rate=ADC_RATE,
            channels=N_CHANNELS,
            inter_kadr_delay=0.002,
            control_table=CONTROL_TABLE,
        )

        # main_ir.m писал word = 0x10000 - DecimUser (без умножения на число
        # каналов).  Сохраняем это поведение явно.
        filters = FilterConfig(
            ntaps=FIR_NTAPS,
            dac_amp=DAC_AMP,
            shift=SHIFT,
            proc_switch=PROC_SWITCH,
            channels=N_CHANNELS,
            decim_word=(0x10000 - DECIM_USER) & 0xFFFF,
            fir_coef1=[0x8000] + [0] * (FIR_TAPS - 1),
            iir_coefs=[0] * IIR_TAPS,
        )
        device.apply_filters(filters)
        print(
            f"Фильтр: ntaps={FIR_NTAPS}, decim_word=0x{filters.decim_word:04X}, "
            f"каналов={N_CHANNELS}"
        )

        samples = device.acquire_all(
            args.blocks,
            timeout_ms=TIME_WAIT_MS,
            buffer_words=BUFFER_WORDS,
        )
        print(f"Получено {len(samples)} отсчётов, max={max(samples)}")

        args.out.parent.mkdir(parents=True, exist_ok=True)
        try:
            import numpy as np

            np.save(args.out, np.frombuffer(samples.tobytes(), dtype=np.int16))
            print(f"Сохранено в {args.out}")
        except ImportError:
            raw = args.out.with_suffix(".bin")
            raw.write_bytes(samples.tobytes())
            print(f"numpy не установлен; сохранено в {raw}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
