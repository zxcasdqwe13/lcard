"""Exceptions raised by the E440 wrapper."""

from __future__ import annotations


class E440Error(RuntimeError):
    def __init__(
        self,
        message: str,
        *,
        action: str | None = None,
        error_number: int | None = None,
    ) -> None:
        self.action = action
        self.error_number = error_number
        text = message
        if error_number is not None:
            text = f"{text} (LCard error {error_number})"
        if action:
            text = f"{action}: {text}"
        super().__init__(text)


class E440NotFound(E440Error):
    pass


class E440Timeout(E440Error):
    pass


class E440Closed(E440Error):
    pass


__all__ = ["E440Closed", "E440Error", "E440NotFound", "E440Timeout"]
