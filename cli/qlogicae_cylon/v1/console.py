from __future__ import annotations

from Cython.Build import cythonize
from library import command_about_manager
from qlogicae_cor.v2.library import log_manager


def main() -> int:
    print("Hello World!")

    print(cythonize)
    print(command_about_manager)
    print(log_manager)

    return 0


if __name__ == "__main__":
    import sys

    sys.exit(
        main()
    )

