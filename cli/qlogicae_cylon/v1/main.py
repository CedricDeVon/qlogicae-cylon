from __future__ import annotations

import subprocess
import sys

from pathlib import Path

def main() -> int:
    result = subprocess.run(
        [sys.executable, str(Path(__file__).parent.resolve() / "app.py"), "build_ext", "--inplace", "--force"],
        check=False,
    )

    exit_code = result.returncode

    return exit_code


if __name__ == "__main__":
    sys.exit(
        main()
    )

