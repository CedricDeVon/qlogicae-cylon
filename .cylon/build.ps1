$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
. "$($public_configurations.scripts.import_utilities)"


Write-Host "- Build Pipeline Begins" -ForegroundColor Green

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_configurations selection $($args[1])
if ($LASTEXITCODE) {
    Write-Host "- Build Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_cython_bindings
if ($LASTEXITCODE) {
    Write-Host "- Build Pipeline Phase 2 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_secrets selection $($args[1])
if ($LASTEXITCODE) {
    Write-Host "- Build Pipeline Phase 4 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

python $public_configurations.scripts.setup_cython_build build_ext --inplace --build-lib $public_configurations.build.output_path
if ($LASTEXITCODE) {
    Write-Host "- Build Pipeline Phase 5 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "- Build Pipeline Complete" -ForegroundColor Green
