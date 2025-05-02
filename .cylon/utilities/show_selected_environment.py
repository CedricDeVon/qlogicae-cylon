import winreg

import globals


def main():
    try:
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, globals.base_sub_key_path) as key:
            val_a, _ = winreg.QueryValueEx(key, globals.application_configurations['selected_key'])

        print(val_a)
            

    except Exception as e:
        print(f"{e}")


if __name__ == "__main__":
    main()

