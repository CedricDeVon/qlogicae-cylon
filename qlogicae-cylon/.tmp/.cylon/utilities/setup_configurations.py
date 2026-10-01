import os
import json
import uuid
import argparse
from pathlib import Path


def main():
    data = {}
    public_configurations = {}
    with open('.cylon/configurations/public.json', 'r') as file:
        public_configurations = json.load(file)

    configuration_output_folder_path = public_configurations['build']['configuration_output_folder_path']
    configuration_output_file_path = public_configurations['build']['configuration_output_file_path']
    
    parser = argparse.ArgumentParser()
    parser.add_argument("--selectedEnvironment", required=True, default='development')
    arguments = parser.parse_args()

    environment = arguments.selectedEnvironment if (arguments.selectedEnvironment) else 'development'
    data = public_configurations['applications']['default']

    for key in public_configurations['applications'][environment]:
        data[key] = public_configurations['applications'][environment][key]

    data['id'] = f"{uuid.uuid4()}"

    Path(configuration_output_folder_path).mkdir(parents=True, exist_ok=True)
    with open(f'{configuration_output_folder_path}/{configuration_output_file_path}', 'w') as out:
        out.write(json.dumps(data, indent=4))

    with open(f"{public_configurations['cylon']['path']}/configurations/{configuration_output_file_path}", 'w') as out:
        out.write(json.dumps(data, indent=4))

    print(f"Configurations Set To '{environment}'")

if __name__ == "__main__":
    main()
