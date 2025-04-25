$CONFIGURATIONS = Get-Content .cylon/configurations.json -Raw | ConvertFrom-Json


Write-Host "- Deployment Pipeline Begins" -ForegroundColor Green

& powershell -NoProfile -ExecutionPolicy Bypass -File $CONFIGURATIONS.SCRIPTS.BUILD
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $CONFIGURATIONS.SCRIPTS.DEPLOY
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $CONFIGURATIONS.SCRIPTS.DEPLOYMENT_FIX
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $CONFIGURATIONS.SCRIPTS.COMPRESSION
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}

Write-Host "- Deployment Pipeline Complete" -ForegroundColor Green
