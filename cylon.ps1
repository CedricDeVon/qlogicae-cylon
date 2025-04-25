$CONFIGURATIONS = Get-Content .cylon/configurations.json -Raw | ConvertFrom-Json

& powershell -NoProfile -ExecutionPolicy Bypass -File "$($CONFIGURATIONS.CYLON.ROOT_FOLDER_PATH)/$($args[0]).ps1" $args
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
