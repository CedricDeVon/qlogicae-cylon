$CONFIGURATIONS = Get-Content .cylon/configurations.json -Raw | ConvertFrom-Json


Write-Host "- Deployment Fix Pipeline Begins" -ForegroundColor Green

if (powershell -NoProfile -Command "Test-Path -Path '$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_FOLDER_PATH)/$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_NAME)'") {
    powershell -NoProfile -Command "Remove-Item -LiteralPath '$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_FOLDER_PATH)/$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_NAME)' -Recurse -Force -ErrorAction SilentlyContinue -Confirm:`$false"
}

powershell -NoProfile -Command "Remove-Item -LiteralPath '$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_FOLDER_PATH)/$($CONFIGURATIONS.DEPLOYMENT.OPENING_FILE_NAME).pyx.build' -Recurse -Force -Confirm:`$false"
if ($LASTEXITCODE) {
    Write-Host "- Deployment Fix Pipeline Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

powershell -NoProfile -Command "Rename-Item -Path '$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_FOLDER_PATH)/$($CONFIGURATIONS.DEPLOYMENT.OPENING_FILE_NAME).pyx.dist' -NewName '$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_NAME)'"
if ($LASTEXITCODE) {
    Write-Host "- Deployment Fix Pipeline Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

powershell -NoProfile -Command "Rename-Item -Path '$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_FOLDER_PATH)/$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_NAME)/$($CONFIGURATIONS.DEPLOYMENT.OPENING_FILE_NAME).pyx.exe' -NewName '$($CONFIGURATIONS.DEPLOYMENT.EXECUTABLE_NAME).exe'"
if ($LASTEXITCODE) {
    Write-Host "- Deployment Fix Pipeline Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

Write-Host "- Deployment Fix Pipeline Complete" -ForegroundColor Green
