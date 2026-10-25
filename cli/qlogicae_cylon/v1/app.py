from __future__ import annotations

import os
import sys
from pathlib import Path

from Cython.Build import cythonize
from setuptools import Extension, setup


PROJECT_ROOT = Path.cwd()
BINDINGS_ROOT = PROJECT_ROOT / "bindings"
PROJECT_SOURCE_ROOT = PROJECT_ROOT / "source"

BINDING_TARGETS = ("c", "cpp")
MISCELLANEOUS_TARGETS = ("setup",)

COMPILER_DIRECTIVES = {
    "language_level": "3",
    "boundscheck": False,
    "wraparound": False,
    "cdivision": True,
    "initializedcheck": False,
    "nonecheck": False,
    "overflowcheck": False,
    "infer_types": True,
}

C_SOURCE_SUFFIXES = {".c"}
CPP_SOURCE_SUFFIXES = {".cpp", ".cc", ".cxx"}


def _get_compiler_args() -> tuple[list[str], list[str]]:
    if sys.platform == "win32":
        return ["/O2"], []

    if sys.platform == "darwin":
        return ["-O3"], []

    if sys.platform.startswith("linux"):
        return ["-O3", "-fopenmp"], ["-fopenmp"]

    return [], []


def _get_source_files(
    folder: Path,
    suffixes: set[str],
) -> list[str]:
    if not folder.is_dir():
        return []

    return sorted(
        str(path)
        for path in folder.rglob("*")
        if path.is_file() and path.suffix.lower() in suffixes
    )


def _find_binding_files(
    binding_target_folder: str,
    binding_root_folder: str = "bindings",
) -> list[Extension]:
    binding_folder = PROJECT_ROOT / binding_root_folder / binding_target_folder
    cython_file = PROJECT_ROOT / binding_root_folder / f"{binding_target_folder}.pyx"

    if not cython_file.is_file():
        raise FileNotFoundError(f"Cython binding not found: {cython_file}")

    if binding_target_folder == "c":
        language = "c"
        source_suffixes = C_SOURCE_SUFFIXES
    elif binding_target_folder == "cpp":
        language = "c++"
        source_suffixes = CPP_SOURCE_SUFFIXES
    else:
        raise ValueError(
            f"Unsupported binding target: {binding_target_folder!r}"
        )

    implementation_files = _get_source_files(
        binding_folder,
        source_suffixes,
    )

    extra_compile_args, extra_link_args = _get_compiler_args()

    return [
        Extension(
            name=f"{binding_root_folder}.{binding_target_folder}",
            sources=[str(cython_file), *implementation_files],
            language=language,
            include_dirs=[
                str(PROJECT_ROOT),
                str(PROJECT_ROOT / binding_root_folder),
            ],
            extra_compile_args=extra_compile_args,
            extra_link_args=extra_link_args,
        )
    ]


def _find_project_source_files(
    base_target_source_folder: str = "source",
) -> list[Extension]:
    source_root = PROJECT_ROOT / base_target_source_folder

    if not source_root.is_dir():
        return []

    extra_compile_args, extra_link_args = _get_compiler_args()
    extensions: list[Extension] = []

    for cython_file in sorted(source_root.rglob("*.pyx")):
        relative_path = cython_file.relative_to(source_root)
        module_path = relative_path.with_suffix("").as_posix().replace("/", ".")

        extensions.append(
            Extension(
                name=f"{base_target_source_folder}.{module_path}",
                sources=[str(cython_file)],
                include_dirs=[
                    str(PROJECT_ROOT),
                    str(BINDINGS_ROOT),
                ],
                extra_compile_args=extra_compile_args,
                extra_link_args=extra_link_args,
            )
        )

    return extensions


def _find_miscellaneous_source_file(
    binding_target_file: str,
    binding_root_folder: str = "bindings",
) -> list[Extension]:
    cython_file = (
        PROJECT_ROOT
        / binding_root_folder
        / f"{binding_target_file}.pyx"
    )

    if not cython_file.is_file():
        raise FileNotFoundError(f"Cython module not found: {cython_file}")

    extra_compile_args, extra_link_args = _get_compiler_args()

    return [
        Extension(
            name=f"{binding_root_folder}.{binding_target_file}",
            sources=[str(cython_file)],
            include_dirs=[
                str(PROJECT_ROOT),
                str(PROJECT_ROOT / binding_root_folder),
            ],
            extra_compile_args=extra_compile_args,
            extra_link_args=extra_link_args,
        )
    ]


def main() -> int:
    extension_paths: list[Extension] = []

    for binding_target in BINDING_TARGETS:
        extension_paths.extend(
            _find_binding_files(binding_target)
        )

    for miscellaneous_target in MISCELLANEOUS_TARGETS:
        extension_paths.extend(
            _find_miscellaneous_source_file(miscellaneous_target)
        )

    extension_paths.extend(
        _find_project_source_files()
    )

    setup(
        ext_modules=cythonize(
            extension_paths,
            compiler_directives=COMPILER_DIRECTIVES,
            include_path=[
                str(PROJECT_ROOT),
                str(BINDINGS_ROOT),
            ],
        ),
        zip_safe=False,
    )

    return 0


if __name__ == "__main__":
    sys.exit(main())