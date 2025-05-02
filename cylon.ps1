$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
. "$($public_configurations.scripts.import_utilities)"


Logger -Message "K"

& powershell -NoProfile -ExecutionPolicy Bypass -File "$($public_configurations.cylon.path)/$($args[0]).ps1" $args
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}
