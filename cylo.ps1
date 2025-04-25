$BASE_COMMANDS_FOLDER="commands"

& powershell -NoProfile -ExecutionPolicy Bypass -File $BASE_COMMANDS_FOLDER/$($args[0]).ps1 $($args[1])
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
