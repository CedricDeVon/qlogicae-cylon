import os
import argparse
import importlib.metadata
from importlib.metadata import PackageNotFoundError


def __get_size(dist):
    size = 0
    files = dist.files or []
    for f in files:
        try:
            located = f.locate()
            if located.is_file():
                size += located.stat().st_size
        except (FileNotFoundError, OSError):
            continue
    return size / 1024


def __find_one(package_name):
    try:
        dist = importlib.metadata.distribution(package_name)
        size = __get_size(dist)
        print(f'{size:>12.4f} KB   {package_name}')
    except PackageNotFoundError:
        print(f"Package not found: {package_name}")


def __find_all():
    total = 0
    for dist in importlib.metadata.distributions():
        size = __get_size(dist)
        total += size
        print(f'{size:>12.4f} KB   {dist.metadata["Name"]}')
    print(f'\n{total:>12.4f} KB   Total')


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--selections", required=True)
    args = parser.parse_args()

    selections = args.selections.strip().split(' ')
    if len(selections) > 1:
        for package_name in selections[1:]:
            __find_one(package_name)
    else:
        __find_all()


if __name__ == "__main__":
    main()
