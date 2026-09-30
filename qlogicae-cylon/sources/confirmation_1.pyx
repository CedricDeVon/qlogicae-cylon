from bindings.c import c_square, c_add
from bindings.cpp import PyMathUtils

from sources.utils.confirmation_2 import confirmation_2

def confirmation_1(str project_name):
    print(f"'confirmation_1' | Import Test: {project_name}")

    print(f"'bindings.c' | Import Test: {c_square(100)}")
    print(f"'bindings.c' | Import Test: {c_add(4, 4)}")
    print(f"'bindings.cpp' | Import Test: {PyMathUtils().test_a(100)}")
    print(f"'bindings.cpp' | Import Test: {PyMathUtils().test_b(102)}")

    confirmation_2(project_name)

