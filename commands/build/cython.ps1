$SETUP_SCRIPT_PATH = "setup.pyx"
$OUTPUT_FOLDER = ".build"

Write-Host "- Cython Build Phase 1 Begins" -ForegroundColor Green
python $SETUP_SCRIPT_PATH clean
if ($LASTEXITCODE -ne 0) {
    Write-Host "- Cython Build Phase 1 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}
Write-Host "- Cython Build Phase 1 Complete" -ForegroundColor Green

Write-Host "- Cython Build Phase 2 Begins" -ForegroundColor Green
python $SETUP_SCRIPT_PATH build_ext --inplace --build-lib $OUTPUT_FOLDER
if ($LASTEXITCODE -ne 0) {
    Write-Host "- Cython Build Phase 2 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}
Write-Host "- Cython Build Phase 2 Complete" -ForegroundColor Green
