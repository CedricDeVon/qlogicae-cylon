import pytest

# pytest.skip("Disabled", allow_module_level=True)

def test_confirmation(benchmark):
    def sum():
        return 1 + 1


    assert benchmark(sum) == 2
