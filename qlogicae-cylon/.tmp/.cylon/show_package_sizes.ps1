$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
. "$($public_configurations.scripts.import_utilities)"


python $public_configurations.scripts.show_package_sizes_utilities --selections=$args
if ($LASTEXITCODE) {
    Write-Host "- Show Package Sizes Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

