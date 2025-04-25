
Write-Host "- Build Pipeline Begins" -ForegroundColor Green
& powershell -NoProfile -ExecutionPolicy Bypass -File commands/build/cython.ps1
if ($LASTEXITCODE -ne 0) {
    Write-Host "- Build Pipeline Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}
Write-Host "- Build Pipeline Complete" -ForegroundColor Green
