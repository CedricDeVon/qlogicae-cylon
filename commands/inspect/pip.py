import sys
import importlib.metadata

def get_package_sizes(package_name=None):
    if package_name:
        # Get a specific package
        try:
            dist = importlib.metadata.distribution(package_name)
            size = sum(
                0 if not f.locate().is_file() else f.locate().stat().st_size
                for f in dist.files
            ) / 1024
            print(f'{size:>12.3f} KB   {package_name}')
        except importlib.metadata.PackageNotFoundError:
            print(f"Package '{package_name}' not found.")
    else:
        # List all packages
        total = 0
        for dist in importlib.metadata.distributions():
            size = sum(
                0 if not f.locate().is_file() else f.locate().stat().st_size
                for f in dist.files
            ) / 1024
            total += size
            print(f'{size:>12.3f} KB   {dist.name}')

        print(f'\n{total:>12.3f} KB   Total')


if __name__ == "__main__":
    # If package names are provided, loop through them
    if len(sys.argv) > 1:
        for package in sys.argv[1:]:
            get_package_sizes(package)  # Get size for each package
    else:
        get_package_sizes()  # List all package sizes
