import os
from Cython.Build import cythonize
from setuptools import setup, Extension


extra_compile_args_set_1 = [
    "/O2",             
    "/GL",             
    "/arch:AVX2",      
    "/fp:fast",        
    "/favor:fast",     
    "/openmp",         
    "/Oi",             
    "/Gy",             
]

extra_link_args_1 = [
    "/LTCG",  
]

def find_binding_files(
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


def find_project_source_files(
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


def find_cylo_source_files(
        root_target_source_folder='.cylo',
        base_target_source_folder='sources',
        a='cylo'):

    extensions = []
    for root, _, files in os.walk(f'{root_target_source_folder}/{base_target_source_folder}'):
        for file in files:
            if file.endswith('.pyx'):
                full_path = os.path.join(root, file)
                module_path = os.path.splitext(
                    os.path.relpath(full_path, f'{root_target_source_folder}/{base_target_source_folder}')
                )[0]
                print(full_path)
                print(module_path)
                extensions.append(Extension(
                    f'{root_target_source_folder}.{base_target_source_folder}.{module_path}',
                    sources=[full_path],
                    extra_compile_args=extra_compile_args_set_1,
                    extra_link_args=extra_link_args_1
                ))
                
    return extensions


def main():
    file_paths = find_binding_files('c') + find_binding_files('cpp') + find_project_source_files() 
    
    setup(
        name='sandbox',
        ext_modules=cythonize(
            file_paths,
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