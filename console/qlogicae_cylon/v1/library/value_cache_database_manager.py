from __future__ import annotations

from typing import Any

__all__ = (
    "ValueCacheDatabaseManager"
)


def _handle_dynamic_imports() -> None:
    global _handle_dynamic_imports

    _handle_dynamic_imports = lambda: None


class ValueCacheDatabaseManager:
    __slots__ = ()

    def __init__(self) -> None:
        _handle_dynamic_imports()
