$CONFIGURATIONS = Get-Content .cylon/configurations.json -Raw | ConvertFrom-Json


Write-Host "- Tar Compression Pipeline Begins" -ForegroundColor Green

python $CONFIGURATIONS.SCRIPTS.COMPRESSION_HANDLER `
    --targetPath "$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_FOLDER_PATH)/$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_NAME)" `
    --outputPath "$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_FOLDER_PATH)/$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_NAME)" `
    --fileExtension "$($CONFIGURATIONS.COMPRESSION.EXTENSION_NAME)"
if ($LASTEXITCODE) {
    Write-Host "- Tar Compression Pipeline Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

Write-Host "- Tar Compression Pipeline Complete" -ForegroundColor Green
