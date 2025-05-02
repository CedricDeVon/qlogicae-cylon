$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


python $public_configurations.scripts.show_secrets_utilities --selectedEnvironment=$($args[1])
if ($LASTEXITCODE) {
    Write-Host "- Show Secrets Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}
