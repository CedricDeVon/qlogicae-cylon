$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


python $public_configurations.scripts.show_package_sizes_utilities --selections=$args
if ($LASTEXITCODE) {
    Write-Host "    - Inspect Packages Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

