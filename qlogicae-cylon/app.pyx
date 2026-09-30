import bindings.setup

from sources.confirmation_1 import confirmation_1
from sources.utils.confirmation_2 import confirmation_2

import json
import winreg


application_configurations = {}
with open('configurations/application.json', 'r') as file:
    application_configurations = json.load(file)


def read_registry(root_key):
    base_sub_key_path = f"{application_configurations['root_sub_key']}\{application_configurations['company']}\{application_configurations['name']}\{application_configurations['version']}\{application_configurations['selected_environment']}"
    try:
        with winreg.OpenKey(root_key, base_sub_key_path) as key:
            val_a, _ = winreg.QueryValueEx(key, application_configurations['sub_data_key'])

        return val_a

    except FileNotFoundError:
        return None


def main():
    confirmation_1('First')
    confirmation_2('Second')
    
    print("From Configurations:", application_configurations)
    print("From HKEY_CURRENT_USER:", read_registry(winreg.HKEY_CURRENT_USER))
    
    v = input()
    
    return


if __name__ == "__main__":
    main()
