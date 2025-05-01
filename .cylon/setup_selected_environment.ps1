$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


python $public_configurations.scripts.setup_selected_environment_utilities --selection=$($args[1])
if ($LASTEXITCODE) {
    Pause
    exit $LASTEXITCODE
}
