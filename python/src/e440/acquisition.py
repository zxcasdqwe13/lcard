"""Double-buffered asynchronous ADC acquisition.

This mirrors ``run_ADC`` from ``main_ir.m``/``LCardControl.m``: two requests
are queued, ``ReadData`` is started on the next buffer before waiting for the
previous one, and the completed buffer is returned to the caller.
"""

from __future__ import annotations

import array
from typing import Iterable, Iterator, Sequence

from .backend.base import Backend, WAIT_OBJECT_0, WAIT_TIMEOUT
from .exceptions import E440Error, E440Timeout
from .model import AdcBlock

DEFAULT_BUFFER_WORDS = 256 * 1024
DEFAULT_TIMEOUT_MS = 3_500_000


def iter_blocks(
    backend: Backend,
    *,
    blocks: int,
    timeout_ms: int = DEFAULT_TIMEOUT_MS,
    buffer_words: int = DEFAULT_BUFFER_WORDS,
    start: bool = True,
    stop: bool = True,
) -> Iterator[AdcBlock]:
    """Yield up to *blocks* ADC buffers as soon as they are available."""
    if blocks <= 0:
        return

    requests = [
        backend.create_request(buffer_words, timeout_ms),
        backend.create_request(buffer_words, timeout_ms),
    ]
    current = 0
    try:
        if start and not backend.start_adc():
            message, number = backend.get_last_error()
            raise E440Error(message, action="START_ADC", error_number=number)

        if not backend.read_async(requests[0]):
            message, number = backend.get_last_error()
            raise E440Error(message, action="ReadData", error_number=number)

        for index in range(blocks):
            if index + 1 < blocks:
                nxt = requests[1 - current]
                if not backend.read_async(nxt):
                    message, number = backend.get_last_error()
                    raise E440Error(
                        message, action="ReadData", error_number=number
                    )

            request = requests[current]
            status = backend.wait(request, timeout_ms)
            if status == WAIT_TIMEOUT:
                raise E440Timeout(
                    f"no ADC data within {timeout_ms} ms", action="WaitForEvent"
                )
            if status != WAIT_OBJECT_0:
                raise E440Error(
                    f"WaitForSingleObject returned 0x{status:08X}",
                    action="WaitForEvent",
                )

            samples = backend.request_data(request)
            yield AdcBlock(
                index=index,
                samples=samples,
                words_passed=backend.request_words_passed(request),
            )
            current = 1 - current
    finally:
        if stop:
            try:
                backend.stop_adc()
            except Exception:
                # Closing must not mask the original error.
                pass
        for request in requests:
            try:
                backend.free_request(request)
            except Exception:
                pass


def collect_blocks(
    backend: Backend,
    *,
    blocks: int,
    timeout_ms: int = DEFAULT_TIMEOUT_MS,
    buffer_words: int = DEFAULT_BUFFER_WORDS,
    start: bool = True,
    stop: bool = True,
) -> array.array:
    """Acquire *blocks* buffers and return all samples in one array."""
    result = array.array("h")
    for block in iter_blocks(
        backend,
        blocks=blocks,
        timeout_ms=timeout_ms,
        buffer_words=buffer_words,
        start=start,
        stop=stop,
    ):
        result.extend(block.samples)  # type: ignore[arg-type]
    return result


def deinterleave(samples: Sequence[int] | array.array, channels: int) -> list[list[int]]:
    """Split interleaved ADC samples into per-channel lists."""
    if channels < 1:
        raise ValueError("channels must be >= 1")
    result: list[list[int]] = [[] for _ in range(channels)]
    for index, value in enumerate(samples):
        result[index % channels].append(value)
    return result


def to_numpy(samples: Iterable[int]):
    """Convert samples to ``numpy.int16``; numpy is an optional dependency."""
    try:
        import numpy as np
    except ImportError as exc:  # pragma: no cover - depends on environment
        raise ImportError(
            "numpy is required for this operation; install it with 'pip install numpy'"
        ) from exc
    return np.frombuffer(array.array("h", samples).tobytes(), dtype=np.int16)


__all__ = [
    "DEFAULT_BUFFER_WORDS",
    "DEFAULT_TIMEOUT_MS",
    "collect_blocks",
    "deinterleave",
    "iter_blocks",
    "to_numpy",
]
