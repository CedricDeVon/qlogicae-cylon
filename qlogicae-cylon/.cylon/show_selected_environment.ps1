$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
. "$($public_configurations.scripts.import_utilities)"


python $public_configurations.scripts.show_selected_environment_utilities
if ($LASTEXITCODE) {
    Write-Host "- Show Selected Environment Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}
