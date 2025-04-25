import os
import tarfile
import argparse
import lzma
from pathlib import Path


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
    parser = argparse.ArgumentParser(description="Compress a folder using tar and optional compression.")
    parser.add_argument("--targetPath", type=str, required=True, help="Path to the folder or file to compress.")
    parser.add_argument("--outputPath", type=str, required=True, help="Base path for the output archive (without extension).")
    parser.add_argument("--fileExtension", type=str, required=True, help="File extension to use.")
    parser.add_argument("--level", type=int, default=9, help="Compression level (only for .xz)")

    args = parser.parse_args()
    compress_folder(args.targetPath, args.outputPath, args.fileExtension, args.level)


if __name__ == "__main__":
    main()
