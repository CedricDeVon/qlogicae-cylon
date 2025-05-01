import sys
import shlex
import ctypes
import winreg
import argparse

import globals

def main():
    try:
        globals.handle_rebooting_if_without_admin_access()

        parser = argparse.ArgumentParser()
        parser.add_argument("--selectedEnvironment", required=True, default=globals.environment_types[0])
        arguments = parser.parse_args()

        root_keys = globals.root_keys.items()
        if (arguments.selectedEnvironment):
            sub_key_value_path = f"{globals.sub_key_base_path}\{arguments.selectedEnvironment}"
            for root_key_name, root_key_data in root_keys:
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
                sub_key_value_path = f"{globals.sub_key_base_path}\{environment_name}"
                for root_key_name, root_key_data in root_keys:
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
        print(f"{e}")

    input()


if __name__ == "__main__":
    main()

