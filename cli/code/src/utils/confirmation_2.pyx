from bindings.c import c_square, c_add
from bindings.cpp import PyMathUtils

def confirmation_2(str project_name):
    print(f"'confirmation_2' | Import Test: {project_name}")

    print(f"'bindings.c' | Import Test: {c_square(100)}")
    print(f"'bindings.c' | Import Test: {c_add(4, 4)}")
    print(f"'bindings.cpp' | Import Test: {PyMathUtils().test_a(100)}")
    print(f"'bindings.cpp' | Import Test: {PyMathUtils().test_b(102)}")

