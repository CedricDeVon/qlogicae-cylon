$CONFIGURATIONS = Get-Content .cylon/configurations.json -Raw | ConvertFrom-Json


& powershell -NoProfile -ExecutionPolicy Bypass -File $CONFIGURATIONS.SCRIPTS.BUILD
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}


Write-Host "- Test Pipeline Begins" -ForegroundColor Green

if ($CONFIGURATIONS.TEST.IS_BENCHMARKING_RESULT_SAVED) {
    pytest $CONFIGURATIONS.TEST.INPUT_FOLDER_PATH --benchmark-save="$($CONFIGURATIONS.TEST.BENCHMARKING_RESULTS_NAME)"
} else {
    pytest $CONFIGURATIONS.TEST.INPUT_FOLDER_PATH
}
if ($LASTEXITCODE) {
    Write-Host "    - Test Pipeline Phase 1 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

Write-Host "- Test Pipeline Complete" -ForegroundColor Green

