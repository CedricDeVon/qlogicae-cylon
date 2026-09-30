import os
import json

import globals


def __setup_imports_file(binding_setup_path):
    with open(binding_setup_path, 'w') as out:
        out.write('')
        

def __setup_source_imports(
        binding_setup_path,
        base_target_source_folder):
    
    imports = set()
    imports.add(base_target_source_folder)
    for root, _, files in os.walk(base_target_source_folder):
        for file in files:
            if file.endswith(('.py', '.pyx')) and '__init__' not in file and not file.startswith('_') and 'setup.pyx' not in file:
                full_path = os.path.join(root, file)
                module_path = os.path.splitext(
                    os.path.relpath(full_path, base_target_source_folder)
                )[0].replace(os.sep, '.')
                imports.add(f'{base_target_source_folder}.{module_path}')
            
            
    with open(binding_setup_path, 'a') as out:
        for package in imports:
            out.write(f'import {package}\n')

        out.write('\n')


def __setup_pip_imports(
        binding_setup_path,
        pip_imports):
    
    with open(binding_setup_path, 'a') as out:
        for package in pip_imports:
            out.write(f'import {package}\n')

        out.write('\n')


def main():
    binding_setup_path = globals.public_configurations['build']['binding_setup_path']
    input_paths = globals.public_configurations['build']['input_paths']
    included_imports = globals.public_configurations['build']['included_imports']

    __setup_imports_file(binding_setup_path)
    for input_path in input_paths:
        __setup_source_imports(binding_setup_path, input_path)

    __setup_pip_imports(binding_setup_path, included_imports)
    

if __name__ == "__main__":
    main()
