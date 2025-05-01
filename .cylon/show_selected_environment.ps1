$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


python $public_configurations.scripts.show_selected_environment_utilities
if ($LASTEXITCODE) {
    Pause
    exit $LASTEXITCODE
}
