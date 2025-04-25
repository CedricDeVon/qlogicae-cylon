param (
    [string]$deploymentRoot,
    [string]$deploymentType,
    [string]$deploymentFolder,
    [string]$deploymentName
)

Write-Host "- Nuitka After-Fix Deployment Begins" -ForegroundColor Green

Write-Host "- Nuitka After-Fix Deployment Phase 1 Begins" -ForegroundColor Green
if (powershell -NoProfile -Command "Test-Path -Path '$deploymentRoot/$deploymentType/$deploymentName'") {
    powershell -NoProfile -Command "Remove-Item -LiteralPath '$deploymentRoot/$deploymentType/$deploymentName' -Recurse -Force -ErrorAction SilentlyContinue -Confirm:`$false"
}
Write-Host "- Nuitka After-Fix Deployment Phase 1 Complete" -ForegroundColor Green

Write-Host "- Nuitka After-Fix Deployment Phase 2 Begins" -ForegroundColor Green
powershell -NoProfile -Command "Remove-Item -LiteralPath '$deploymentRoot/$deploymentType/$deploymentFolder.build' -Recurse -Force -Confirm:`$false"
if ($LASTEXITCODE -ne 0) {
    Write-Host "- Nuitka After-Fix Deployment Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}
Write-Host "- Nuitka After-Fix Deployment Phase 2 Complete" -ForegroundColor Green


Write-Host "- Nuitka After-Fix Deployment Phase 3 Begins" -ForegroundColor Green
powershell -NoProfile -Command "Rename-Item -Path '$deploymentRoot/$deploymentType/$deploymentFolder.dist' -NewName '$deploymentName'"
if ($LASTEXITCODE -ne 0) {
    Write-Host "- Nuitka After-Fix Deployment Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}
Write-Host "- Nuitka After-Fix Deployment Phase 3 Complete" -ForegroundColor Green


Write-Host "- Nuitka After-Fix Deployment Phase 4 Begins" -ForegroundColor Green
powershell -NoProfile -Command "Rename-Item -Path '$deploymentRoot/$deploymentType/$deploymentName/$deploymentFolder.exe' -NewName '$deploymentName.exe'"
if ($LASTEXITCODE -ne 0) {
    Write-Host "- Nuitka After-Fix Deployment Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}
Write-Host "- Nuitka After-Fix Deployment Phase 4 Complete" -ForegroundColor Green

Write-Host "- Nuitka After-Fix Deployment Complete" -ForegroundColor Green
