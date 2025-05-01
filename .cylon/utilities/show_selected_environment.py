import winreg

import globals


def main():
    try:
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, f"{globals.public_configurations['environment']['base_key']}\{globals.public_configurations['application']['company']}\{globals.public_configurations['application']['name']}\{globals.public_configurations['application']['version']}") as key:
            val_a, _ = winreg.QueryValueEx(key, globals.public_configurations['environment']['selected_key'])

        print(val_a)
            

    except Exception as e:
        print(f"{e}")


if __name__ == "__main__":
    main()

