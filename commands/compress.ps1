param (
    [string]$TargetPath,
    [string]$OutputPath
)

$COMPRESSION_SCRIPT_PATH = "commands/compress/tar.py"
$EXTENSION_NAME = "tar.xz"

Write-Host "- Compression Pipeline Begins" -ForegroundColor Green
python $COMPRESSION_SCRIPT_PATH --targetPath $TargetPath --outputPath $OutputPath --fileExtension $EXTENSION_NAME
if ($LASTEXITCODE -ne 0) {
    Write-Host "- Compression Pipeline Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}
Write-Host "- Compression Pipeline Complete" -ForegroundColor Green
