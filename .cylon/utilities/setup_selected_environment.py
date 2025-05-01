import winreg
import argparse

import globals

def main():
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--selection", required=True, default=globals.public_configurations['build']['default_environment'])
        arguments = parser.parse_args()

        sub_key_selected_environment_path = f"{globals.public_configurations['environment']['base_key']}\{globals.public_configurations['application']['company']}\{globals.public_configurations['application']['name']}\{globals.public_configurations['application']['version']}"
        key = winreg.CreateKeyEx(globals.root_keys['hkcu']['value'], sub_key_selected_environment_path, 0, winreg.KEY_SET_VALUE)
        winreg.SetValueEx(key, globals.public_configurations['environment']['selected_key'], 0, winreg.REG_SZ, arguments.selection or globals.public_configurations['build']['default_environment'])
        
        winreg.CloseKey(key)
        
    except Exception as e:
        print(f"{e}")


if __name__ == "__main__":
    main()
