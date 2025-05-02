$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
. "$($public_configurations.scripts.import_utilities)"


Write-Host "- Release Begins" -ForegroundColor Green

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.build selection release
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.compile selection $($public_configurations.compilation.platform)
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}

# & powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.compress selection $($public_configurations.compression.type)
# if ($LASTEXITCODE) {
#     exit $LASTEXITCODE
# }

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_installment
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_configurations selection development
if ($LASTEXITCODE) {
    Write-Host "- Build Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "- Release Complete" -ForegroundColor Green
