from __future__ import annotations


def main() -> int:
    print("Hello World!")

    result: bool = True
    return 0 if result else 1


if __name__ == "__main__":
    import sys

    sys.exit(
        main()
    )

