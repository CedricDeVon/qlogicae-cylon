import os
import tarfile
import argparse

console_parser = argparse.ArgumentParser()
console_parser.add_argument("--targetPath", type=str, required=True)
console_parser.add_argument("--outputPath", type=str, required=True)
console_parser.add_argument("--fileExtension", type=str, required=True)
console_arguments = console_parser.parse_args()

compression_level = 9
file_writing_method = 'w:xz'
target_full_path = console_arguments.targetPath
output_full_path = f'{console_arguments.outputPath}.{console_arguments.fileExtension}'

with tarfile.open(output_full_path, file_writing_method, preset=compression_level) as tar:
    tar.add(target_full_path, arcname=os.path.basename(target_full_path))

