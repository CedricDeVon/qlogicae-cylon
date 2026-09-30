import sys
import shlex
import ctypes
import winreg
import argparse

import globals


def main():
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--selectedEnvironment", required=True, default=globals.environment_types[0])
        arguments = parser.parse_args()

        is_other_than_hkcu_used = globals.private_configurations['windows_registry']['is_root_key_used']['hklm'] or globals.private_configurations['windows_registry']['is_root_key_used']['hkcr'] or globals.private_configurations['windows_registry']['is_root_key_used']['hkcc']
        if is_other_than_hkcu_used:
            globals.handle_rebooting_if_without_admin_access()
            return

        root_keys = globals.root_keys.items()
        if (arguments.selectedEnvironment):
            selected_environment = arguments.selectedEnvironment if (arguments.selectedEnvironment) else globals.environment_types[0]
            if selected_environment not in globals.environment_types:
                raise Exception(f"'{selected_environment}' is not a valid environment type")
                return

            sub_key_value_path = f"{globals.base_sub_key_path}\{arguments.selectedEnvironment}"
            for root_key_name, root_key_data in root_keys:
                if globals.private_configurations['windows_registry']['is_root_key_used'][root_key_name]:
                    print(f"- {root_key_data['name']}")
                    with winreg.OpenKey(root_key_data['value'], sub_key_value_path, 0, winreg.KEY_READ) as key:
                        index = 0
                        while True:
                            try:
                                value_name, value_data, value_type = winreg.EnumValue(key, index)
                                print(f"    - {value_name}: {value_data}")
                                index += 1

                            except OSError:
                                break

        else:
            for environment_name in globals.environment_types:
                print(environment_name)
                sub_key_value_path = f"{globals.base_sub_key_path}\{environment_name}"
                for root_key_name, root_key_data in root_keys:
                    if globals.private_configurations['windows_registry']['is_root_key_used'][root_key_name]:
                        print(f"- {root_key_data['name']}")
                        with winreg.OpenKey(root_key_data['value'], sub_key_value_path, 0, winreg.KEY_READ) as key:
                            index = 0
                            while True:
                                try:
                                    value_name, value_data, value_type = winreg.EnumValue(key, index)
                                    print(f"    - {value_name}: {value_data}")
                                    index += 1

                                except OSError:
                                    break

                print()


    except Exception as e:
        raise Exception(f"{e}")


if __name__ == "__main__":
    main()

