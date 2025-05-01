$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json

Write-Host "- Build Pipeline Begins" -ForegroundColor Green

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_configurations
if ($LASTEXITCODE) {
    Write-Host "    - Build Pipeline Phase 1 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_cython_bindings
if ($LASTEXITCODE) {
    Write-Host "    - Build Pipeline Phase 2 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_selected_environment default $($args[1])
if ($LASTEXITCODE) {
    Write-Host "    - Build Pipeline Phase 3 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_secrets default $($args[1])
if ($LASTEXITCODE) {
    Write-Host "    - Build Pipeline Phase 4 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

python $public_configurations.scripts.setup_cython_build build_ext --inplace --build-lib $public_configurations.build.output_path
if ($LASTEXITCODE) {
    Write-Host "    - Build Pipeline Phase 5 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

Write-Host "- Build Pipeline Complete" -ForegroundColor Green
