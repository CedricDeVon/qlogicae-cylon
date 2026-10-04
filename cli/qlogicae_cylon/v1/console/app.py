from __future__ import annotations
from .._vendor.cython.Cython.Build import cythonize

def main() -> int:
    print("Hello World!")
    print(cythonize)

    result: bool = True
    return 0 if result else 1


if __name__ == "__main__":
    import sys

    sys.exit(
        main()
    )

