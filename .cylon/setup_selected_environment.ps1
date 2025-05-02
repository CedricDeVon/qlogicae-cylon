$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


Write-Host "- Environment Selection Pipeline Begins" -ForegroundColor Green

python $public_configurations.scripts.setup_selected_environment_utilities --selection=$($args[1])
if ($LASTEXITCODE) {
    Write-Host "- Environment Selection Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "- Environment Selection Pipeline Complete" -ForegroundColor Green
