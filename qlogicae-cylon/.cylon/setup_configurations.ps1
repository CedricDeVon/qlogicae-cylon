$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
. "$($public_configurations.scripts.import_utilities)"


Write-Host "- Configurations Setup Pipeline Begins" -ForegroundColor Green

python $public_configurations.scripts.setup_configurations_utilities --selectedEnvironment=$($args[1]) 
if ($LASTEXITCODE) {
    Write-Host "- Configurations Setup Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "- Configurations Setup Pipeline Complete" -ForegroundColor Green
