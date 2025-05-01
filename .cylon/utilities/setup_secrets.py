import sys
import json
import shlex
import ctypes
import winreg
import argparse

import globals

def main():
    try:
        globals.handle_rebooting_if_without_admin_access()

        parser = argparse.ArgumentParser()
        parser.add_argument("--selectedEnvironment", required=True, default='development')
        arguments = parser.parse_args()

        environment_variables = {}
        selected_environment = arguments.selectedEnvironment if (arguments.selectedEnvironment) else 'development'
        for key, value in globals.private_configurations['windows_registry']['format'].items():
            environment_variables[key] = value

        for key, value in globals.private_configurations['windows_registry'][selected_environment].items():
            environment_variables[key] = value
        
        sub_key_value_path = f"{globals.public_configurations['environment']['base_key']}\{globals.public_configurations['application']['company']}\{globals.public_configurations['application']['name']}\{globals.public_configurations['application']['version']}\{selected_environment}"
        
        for key_name, value in environment_variables.items():
            try:
                key = winreg.CreateKeyEx(globals.root_keys[key_name]['value'], sub_key_value_path, 0, winreg.KEY_SET_VALUE)
                winreg.SetValueEx(key, globals.public_configurations['environment']['base_data_sub_key'], 0, winreg.REG_SZ, json.dumps(value))
                winreg.CloseKey(key)
                print(f"'{key_name}' Set Inside '{selected_environment}'")
            
            except PermissionError:
                print(f"Permission Denied For {key_name}.")

            except Exception as e:
                print(f"Error Setting Value Under {key_name}: {e}")

    except Exception as e:
        print(f"{e}")

    input()


if __name__ == "__main__":
    main()

