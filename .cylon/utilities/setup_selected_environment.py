import winreg
import argparse

import globals

def main():
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--selection", required=True, default=globals.public_configurations['build']['default_environment'])
        arguments = parser.parse_args()
        selected_environment = arguments.selection if (arguments.selection) else globals.environment_types[0]
        if selected_environment not in globals.environment_types:
            raise Exception(f"'{selected_environment}' is not a valid environment type")
            return

        key = winreg.CreateKeyEx(globals.root_keys['hkcu']['value'], globals.base_sub_key_path, 0, winreg.KEY_SET_VALUE)
        winreg.SetValueEx(key, globals.application_configurations['selected_key'], 0, winreg.REG_SZ, arguments.selection or globals.public_configurations['build']['default_environment'])
        
        winreg.CloseKey(key)
        
    except Exception as e:
        print(f"{e}")


if __name__ == "__main__":
    main()
