# Import Binding Files Here
from bindings import c, cpp

# Import Every Project Modules Here Within The 'Sources' Folder
import sources
from sources.confirmation_1 import confirmation_1
from sources.utils.confirmation_2 import confirmation_2


def main():
    confirmation_1('First')
    confirmation_2('Second')
    v = input()
    
    return


if __name__ == "__main__":
    main()
