$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_selected_environment default testing
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}


Write-Host "- Test Pipeline Begins" -ForegroundColor Green

if ($public_configurations.testing.is_benchmarking_saved) {
    pytest $public_configurations.testing.input_path --benchmark-save="$($public_configurations.testing.benchmarking_output_path)"
} else {
    pytest $public_configurations.testing.input_path
}
if ($LASTEXITCODE) {
    Write-Host "    - Test Pipeline Phase 1 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}


& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_selected_environment default development
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}


Write-Host "- Test Pipeline Complete" -ForegroundColor Green

