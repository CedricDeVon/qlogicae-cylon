import os
import json
from pathlib import Path

import globals


def main():
    data = {}
    configuration_output_folder_path = globals.public_configurations['build']['configuration_output_folder_path']
    configuration_output_file_path = globals.public_configurations['build']['configuration_output_file_path']
    configuration_sections = globals.public_configurations['build']['configuration_sections']

    for configuration_section in configuration_sections:
        data[configuration_section] = globals.public_configurations[configuration_section]

    Path(configuration_output_folder_path).mkdir(parents=True, exist_ok=True)

    with open(f'{configuration_output_folder_path}/{configuration_output_file_path}', 'w') as out:
        out.write(json.dumps(data, indent=4))

if __name__ == "__main__":
    main()
