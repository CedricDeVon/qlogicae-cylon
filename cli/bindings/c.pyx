cdef extern from "c/includes/square.h":
    int square(int x)

def c_square(int x):
    return square(x)

cdef extern from "c/includes/add.h":
    int add(int x, int y)

def c_add(int x, int y):
    return add(x, y)
