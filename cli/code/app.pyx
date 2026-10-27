import bindings.setup

from src.confirmation_1 import confirmation_1
from src.utils.confirmation_2 import confirmation_2


def main():
    confirmation_1('First')
    confirmation_2('Second')
    
    v = input()
    
    return


if __name__ == "__main__":
    main()
