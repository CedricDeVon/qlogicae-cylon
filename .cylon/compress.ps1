$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
. "$($public_configurations.scripts.import_utilities)"


Write-Host "- Compression Pipeline Begins" -ForegroundColor Green

if ($args[1] -match "tar.xz") {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.setup_tar_compression
}

if ($LASTEXITCODE) {
    Write-Host "- Compression Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "- Compression Pipeline Complete" -ForegroundColor Green
