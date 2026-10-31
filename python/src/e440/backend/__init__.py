"""Device backends: real LCard DLL (Windows) and an in-memory simulator."""

from .base import Backend, BackendUnavailable, WAIT_OBJECT_0, WAIT_TIMEOUT
from .mock import MockBackend
from .windows import WindowsBackend

__all__ = [
    "Backend",
    "BackendUnavailable",
    "MockBackend",
    "WAIT_OBJECT_0",
    "WAIT_TIMEOUT",
    "WindowsBackend",
]
