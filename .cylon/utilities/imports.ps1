$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
. "$($public_configurations.scripts.logger_utilities)"
