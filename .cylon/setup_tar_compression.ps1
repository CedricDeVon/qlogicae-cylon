$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


Write-Host "- Tar Compression Setup Pipeline Begins" -ForegroundColor Green

python $public_configurations.scripts.setup_tar_compression_utilities
if ($LASTEXITCODE) {
    Write-Host "- Tar Compression Setup Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "- Tar Compression Setup Pipeline Complete" -ForegroundColor Green
