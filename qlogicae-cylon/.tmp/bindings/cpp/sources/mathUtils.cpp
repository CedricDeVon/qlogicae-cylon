#include <vector>
#include <string>

#include "../../c/sources/square.c"
#include "../includes/mathUtils.hpp"

std::vector<int> MathUtils::test_a(int x) {
    std::vector<int> items;
    for (int i = 0; i < x; ++i)
    {
        items.push_back(i);
    }

    return items;
}

int MathUtils::test_b(int x) {
    return square(x);
}

