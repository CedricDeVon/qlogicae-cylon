import os
import json
from itertools import chain
from Cython.Build import cythonize
from setuptools import setup, Extension

import globals


binding_input_paths = globals.public_configurations['build']['binding_input_paths']
binding_miscellaneous_input_paths = globals.public_configurations['build']['binding_miscellaneous_input_paths']
extra_compile_args_set_1 = globals.public_configurations['build']['extra_compile_args_set_1']
extra_link_args_1 = globals.public_configurations['build']['extra_link_args_1']


def __find_binding_files(
        binding_target_folder,
        binding_root_folder='bindings',
        binding_target_source_folder='sources'):

    source_files = [f'{binding_root_folder}\{binding_target_folder}.pyx']
    for root, _, files in os.walk(f'{binding_root_folder}\{binding_target_folder}\{binding_target_source_folder}'):
        for file in files:
            full_path = os.path.join(root, file)
            source_files.append(full_path)

    return [Extension(
        f'{binding_root_folder}.{binding_target_folder}',
        sources=source_files,
        language=binding_target_folder,
        extra_compile_args=extra_compile_args_set_1,
        extra_link_args=extra_link_args_1
    )]


def __find_project_source_files(
        base_target_source_folder='sources'):

    extensions = []
    for root, _, files in os.walk(base_target_source_folder):
        for file in files:
            if file.endswith('.pyx'):
                full_path = os.path.join(root, file)
                module_path = os.path.splitext(
                    os.path.relpath(full_path, base_target_source_folder)
                )[0].replace(os.sep, '.')
                extensions.append(Extension(
                    f'{base_target_source_folder}.{module_path}',
                    sources=[full_path],
                    extra_compile_args=extra_compile_args_set_1,
                    extra_link_args=extra_link_args_1
                ))
    
    return extensions


def __find_miscellaneous_source_file(
        binding_target_file,
        binding_root_folder='bindings',
        binding_target_source_folder='sources'):

    source_files = [f'{binding_root_folder}\{binding_target_file}.pyx']

    return [Extension(
        f'{binding_root_folder}.{binding_target_file}',
        sources=source_files,
        extra_compile_args=extra_compile_args_set_1,
        extra_link_args=extra_link_args_1
    )]


def main():
    extension_paths = []
    for binding_input_path in binding_input_paths:
        extension_paths = list(chain(extension_paths, __find_binding_files(binding_input_path)))

    for binding_miscellaneous_input_path in binding_miscellaneous_input_paths:
        extension_paths = list(chain(extension_paths, __find_miscellaneous_source_file(binding_miscellaneous_input_path)))

    extension_paths = list(chain(extension_paths, __find_project_source_files()))
    
    setup(
        name='sandbox',
        ext_modules=cythonize(
            extension_paths,
            compiler_directives={
                "language_level": "3",      
                "boundscheck": False,       
                "wraparound": False,        
                "cdivision": True,          
                "initializedcheck": False,  
                "nonecheck": False,         
                "overflowcheck": False,     
                "infer_types": True,
            },
            include_path=[]
        ),
        zip_safe=False,
    )

    return


if __name__ == "__main__":
    main()


# import numpy
# numpy.get_include()