$CONFIGURATIONS = Get-Content .cylon/configurations.json -Raw | ConvertFrom-Json


Write-Host "- Build Pipeline Begins" -ForegroundColor Green

python $CONFIGURATIONS.SCRIPTS.SETUP clean
if ($LASTEXITCODE) {
    Write-Host "    - Build Pipeline Phase 1 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

python $CONFIGURATIONS.SCRIPTS.SETUP build_ext --inplace --build-lib $CONFIGURATIONS.BUILD.OUTPUT_FOLDER_PATH
if ($LASTEXITCODE) {
    Write-Host "    - Build Pipeline Phase 2 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

Write-Host "- Build Pipeline Complete" -ForegroundColor Green
