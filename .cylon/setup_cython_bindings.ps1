$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


python $public_configurations.scripts.setup_cython_bindings_utility
if ($LASTEXITCODE) {
    Write-Host "    - Inspect Packages Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}
