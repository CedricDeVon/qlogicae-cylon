$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
. "$($public_configurations.scripts.import_utilities)"


& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.build selection development
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}

python "$($public_configurations.compilation.entry_path).pyx"
if ($LASTEXITCODE) {
    Write-Host "- Configurations Setup Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}
