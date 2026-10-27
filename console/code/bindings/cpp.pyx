# distutils: language = c++

from libcpp.vector cimport vector

cdef extern from "cpp/includes/mathUtils.hpp":
    cdef cppclass MathUtils:
        MathUtils() except +
        int test_b(int)
        vector[int] test_a(int)

cdef class PyMathUtils:
    cdef MathUtils* thisptr

    def __cinit__(self):
        self.thisptr = new MathUtils()

    def __dealloc__(self):
        del self.thisptr

    def test_b(self, int x):
        return self.thisptr.test_b(x)

    def test_a(self, int x):
        return self.thisptr.test_a(x)
