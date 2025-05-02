import sys
import json
import shlex
import ctypes
import winreg
import argparse

import globals


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--selectedEnvironment", required=True, default=globals.environment_types[0])
    arguments = parser.parse_args()

    is_other_than_hkcu_used = globals.private_configurations['windows_registry']['is_root_key_used']['hklm'] or globals.private_configurations['windows_registry']['is_root_key_used']['hkcr'] or globals.private_configurations['windows_registry']['is_root_key_used']['hkcc']
    if is_other_than_hkcu_used:
        globals.handle_rebooting_if_without_admin_access()
        return

    secrets = {}
    selected_environment = arguments.selectedEnvironment if (arguments.selectedEnvironment) else globals.environment_types[0]
    if selected_environment not in globals.environment_types:
        raise Exception(f"'{selected_environment}' is not a valid environment type")
        return

    for key, value in globals.private_configurations['windows_registry']['default'].items():
        if globals.private_configurations['windows_registry']['is_root_key_used'][key]:
            secrets[key] = value
        

    for key, value in globals.private_configurations['windows_registry'][selected_environment].items():
        if globals.private_configurations['windows_registry']['is_root_key_used'][key]:
            secrets[key] = value
        
    for key_name, value in secrets.items():
        try:
            key = winreg.CreateKeyEx(globals.root_keys[key_name]['value'], f"{globals.base_sub_key_path}\{selected_environment}", 0, winreg.KEY_SET_VALUE)
            winreg.SetValueEx(key, globals.application_configurations['sub_data_key'], 0, winreg.REG_SZ, json.dumps(value))
            winreg.CloseKey(key)
            print(f"'{key_name}' Set Inside '{selected_environment}'")
        
        except PermissionError:
            raise Exception(f"Permission Denied For {key_name}.")

        except Exception as e:
            raise Exception(f"Error Setting Value Under {key_name}: {e}")


if __name__ == "__main__":
    main()

