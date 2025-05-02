$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


Write-Host "- Cython Bindings Setup Pipeline Begins" -ForegroundColor Green

python $public_configurations.scripts.setup_cython_bindings_utility
if ($LASTEXITCODE) {
    Write-Host "- Cython Bindings Setup Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "- Cython Bindings Setup Pipeline Complete" -ForegroundColor Green
