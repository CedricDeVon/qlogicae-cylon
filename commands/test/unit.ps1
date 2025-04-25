$TEST_FOLDER = "tests/"
$BUILD_SCRIPT_PATH = "commands/build.ps1"
$UNIT_TEST_SCRIPT_PATH = "commands/test/unit.ps1"

& powershell -NoProfile -ExecutionPolicy Bypass -File $BUILD_SCRIPT_PATH
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "- Unit Test Phase 1 Begins" -ForegroundColor Green
pytest $TEST_FOLDER
if ($LASTEXITCODE -ne 0) {
    Write-Host "    - Unit Test Phase 1 Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}
Write-Host "- Unit Test Phase 1 Complete" -ForegroundColor Green

