$PROJECT_VERSION = "1.0.1"
$DEPLOYMENT_APPLICATION_NAME = "project"

$DEPLOYMENT_TYPE = "nuitka"
$APPLICATION_TYPE = "console"
$OPENING_BASE_FILE_NAME = "app"

$ICON_PATH = "public/icon.ico"
$SOURCE_FOLDER_PATH = "sources"
$DISTRIBUTABLE_FOLDER = ".releases"
$BUILD_SCRIPT_PATH = "commands/build.ps1"
$COMPRESSION_SCRIPT_PATH = "commands/compress.ps1"
$DEPLOYMENT_AFTER_FIX_SCRIPT_PATH = "commands/deploy/nuitka/after-fix.ps1"
$COMPRESSION_INPUT_PATH = "$DISTRIBUTABLE_FOLDER/$DEPLOYMENT_TYPE/$DEPLOYMENT_APPLICATION_NAME"
$COMPRESSION_OUTPUT_PATH = "$DISTRIBUTABLE_FOLDER/$DEPLOYMENT_TYPE/$DEPLOYMENT_APPLICATION_NAME"

Write-Host "- Deployment Pipeline Begins" -ForegroundColor Green

$deployScriptPath = "commands/deploy/$DEPLOYMENT_TYPE/$APPLICATION_TYPE.ps1"
& powershell -NoProfile -ExecutionPolicy Bypass -File $deployScriptPath `
    -BaseFileName $OPENING_BASE_FILE_NAME `
    -DeploymentType $DEPLOYMENT_TYPE `
    -SourcePackage $SOURCE_FOLDER_PATH `
    -IconPath $ICON_PATH `
    -OutputRoot $DISTRIBUTABLE_FOLDER `
    -BuildScriptPath $BUILD_SCRIPT_PATH `
    -ProductName $DEPLOYMENT_APPLICATION_NAME `
    -ProjectVersion $PROJECT_VERSION
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $DEPLOYMENT_AFTER_FIX_SCRIPT_PATH `
    -deploymentRoot $DISTRIBUTABLE_FOLDER `
    -deploymentType $DEPLOYMENT_TYPE `
    -deploymentFolder "$OPENING_BASE_FILE_NAME.pyx" `
    -deploymentName $DEPLOYMENT_APPLICATION_NAME
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $COMPRESSION_SCRIPT_PATH `
    -TargetPath $COMPRESSION_INPUT_PATH `
    -OutputPath $COMPRESSION_OUTPUT_PATH
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "- Deployment Pipeline Complete" -ForegroundColor Green

Pause
