import sys
import json
import shlex
import ctypes
import winreg
import argparse

root_keys = {
    'hkcu': {
        'name': 'HKEY_CURRENT_USER',
        'value': winreg.HKEY_CURRENT_USER
    },
    'hklm': {
        'name': 'HKEY_LOCAL_MACHINE',
        'value': winreg.HKEY_LOCAL_MACHINE
    },
    'hkcr': {
        'name': 'HKEY_CLASSES_ROOT',
        'value': winreg.HKEY_CLASSES_ROOT
    },
    'hkcc': {
        'name': 'HKEY_CURRENT_CONFIG',
        'value': winreg.HKEY_CURRENT_CONFIG
    },
}

private_configurations = {}
with open('.cylon/configurations/private.json', 'r') as file:
    private_configurations = json.load(file)

public_configurations = {}
with open('.cylon/configurations/public.json', 'r') as file:
    public_configurations = json.load(file)

application_configurations = {}
with open('.cylon/configurations/application.json', 'r') as file:
    application_configurations = json.load(file)

environment_types = public_configurations['build']['environment_selections']

def handle_rebooting_if_without_admin_access():
    if not ctypes.windll.shell32.IsUserAnAdmin():
        if private_configurations['windows_registry']['show_logs']:        
            quoted_args = ' '.join(f'"{arg}"' for arg in sys.argv[1:])
            ctypes.windll.shell32.ShellExecuteW(
                None, 'runas', sys.executable, f'"{sys.argv[0]}" {quoted_args}', None, 1
            )
        else:
            quoted_args = shlex.join(sys.argv[1:])
            ctypes.windll.shell32.ShellExecuteW(
                None, 'runas', sys.executable, f'"{sys.argv[0]}" {quoted_args}', None, 0                       
            )
        sys.exit()

base_sub_key_path = f"{application_configurations['root_sub_key']}\{application_configurations['company']}\{application_configurations['name']}\{application_configurations['version']}"
