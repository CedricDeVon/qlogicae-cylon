$CONFIGURATIONS = Get-Content .cylon/configurations.json -Raw | ConvertFrom-Json


python $CONFIGURATIONS.SCRIPTS.PACKAGE_SIZES_HANDLER --selections=$args
if ($LASTEXITCODE) {
    Write-Host "    - Inspect Packages Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

