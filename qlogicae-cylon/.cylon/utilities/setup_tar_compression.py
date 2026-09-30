import os
import lzma
import tarfile
import argparse
from pathlib import Path

import globals


def compress_folder(
    target_path: str,
    output_path: str,
    file_extension: str,
    compression_level: int = 9
):
    target = Path(target_path)
    output = Path(f"{output_path}.{file_extension}")

    if file_extension == "tar.xz":
        # Use lzma with compression level
        preset = compression_level
        file_mode = "w:xz"
        compress_opts = {"preset": preset}

    elif file_extension == "tar.gz":
        file_mode = "w:gz"
        compress_opts = {}
        
    else:
        file_mode = "w"
        compress_opts = {}

    try:
        with tarfile.open(output, mode=file_mode, **compress_opts) as tar:
            tar.add(target, arcname=target.name)
        print(f"Compressed '{target}' → '{output}'")

    except Exception as e:
        print(f"[ERROR] Compression failed: {e}")


def main():
    input_path = f"{globals.public_configurations['compilation']['output_path']}/{globals.public_configurations['application']['name']}/{globals.public_configurations['application']['name']}"
    output_path = input_path
    compress_folder(input_path, output_path, globals.public_configurations['compression']['type'], globals.public_configurations['compression']['level'])


if __name__ == "__main__":
    main()
