import bindings.setup

from sources.confirmation_1 import confirmation_1
from sources.utils.confirmation_2 import confirmation_2

import os
import json
import winreg


public_configurations = {}
with open('configurations/cylon.json', 'r') as file:
    public_configurations = json.load(file)


def read_registry(root_key):
    try:
        with winreg.OpenKey(root_key, f"{public_configurations['environment']['base_key']}\{public_configurations['application']['company']}\{public_configurations['application']['name']}\{public_configurations['application']['version']}") as key:
            val_a, _ = winreg.QueryValueEx(key, public_configurations['environment']['selected_key'])

        print(val_a)
            
        with winreg.OpenKey(root_key, f"{public_configurations['environment']['base_key']}\{public_configurations['application']['company']}\{public_configurations['application']['name']}\{public_configurations['application']['version']}\{val_a}") as key:
            val_b, _ = winreg.QueryValueEx(key, public_configurations['environment']['base_data_sub_key'])
            
        return val_b

    except FileNotFoundError:
        return None



def main():
    confirmation_1('First')
    confirmation_2('Second')
    
    print("From Configurations:", public_configurations)
    print("From HKEY_CURRENT_USER:", read_registry(winreg.HKEY_CURRENT_USER))
    print("From HKEY_LOCAL_MACHINE:", read_registry(winreg.HKEY_LOCAL_MACHINE))
    print("From HKEY_CLASSES_ROOT:", read_registry(winreg.HKEY_CLASSES_ROOT))
    print("From HKEY_CURRENT_CONFIG:", read_registry(winreg.HKEY_CURRENT_CONFIG))
    
    v = input()
    
    return


if __name__ == "__main__":
    main()
