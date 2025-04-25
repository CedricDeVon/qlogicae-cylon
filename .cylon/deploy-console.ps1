$CONFIGURATIONS = Get-Content .cylon/configurations.json -Raw | ConvertFrom-Json


Write-Host "- Console Deployment Pipeline Begins" -ForegroundColor Green

& nuitka "$($CONFIGURATIONS.DEPLOYMENT.OPENING_FILE_NAME).pyx" `
    --standalone `
    --follow-imports `
    --lto=yes `
    --static-libpython=no `
    --assume-yes-for-downloads `
    --msvc=latest `
    --nofollow-import-to="$($CONFIGURATIONS.DEPLOYMENT.EXCLUDED_IMPORTS)" `
    --noinclude-pytest-mode=nofollow `
    --nofollow-import-to=tkinter `
    --output-dir="$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_FOLDER_PATH)" `
    --include-data-dir=$($CONFIGURATIONS.DEPLOYMENT.SOURCE_FOLDER_PATH)=$($CONFIGURATIONS.DEPLOYMENT.SOURCE_FOLDER_PATH) `
    --include-package="$($CONFIGURATIONS.DEPLOYMENT.SOURCE_FOLDER_PATH)" `
    --product-name="$($CONFIGURATIONS.DEPLOYMENT.OUTPUT_NAME)" `
    --file-version="$($CONFIGURATIONS.DEPLOYMENT.VERSION)" `
    --file-description="$($CONFIGURATIONS.DEPLOYMENT.DESCRIPTION)" `
    --windows-icon-from-ico="$($CONFIGURATIONS.DEPLOYMENT.ICON_FILE_PATH)" `
    --windows-console-mode=force `
    --report="$($CONFIGURATIONS.DEPLOYMENT.REPORT_OUTPUT_PATH)"
if ($LASTEXITCODE) {
    Write-Host "- Console Deployment Pipeline Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

Write-Host "- Console Deployment Pipeline Complete" -ForegroundColor Green
