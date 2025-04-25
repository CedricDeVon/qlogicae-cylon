param (
    [string]$BaseFileName,        
    [string]$DeploymentType,      
    [string]$SourcePackage,       
    [string]$IconPath,            
    [string]$OutputRoot,           
    [string]$BuildScriptPath,
    [string]$ProductName,
    [string]$ProjectVersion
)

& powershell -NoProfile -ExecutionPolicy Bypass -File $BuildScriptPath
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "- Nuitka Console Deployment Begins" -ForegroundColor Green
& nuitka "$BaseFileName.pyx" `
    --standalone `
    --follow-imports `
    --lto=yes `
    --static-libpython=no `
    --assume-yes-for-downloads `
    --msvc=latest `
    --nofollow-import-to=setuptools,pkg_resources,libcrypto `
    --noinclude-pytest-mode=nofollow `
    --nofollow-import-to=tkinter `
    --output-dir="$OutputRoot/$DeploymentType" `
    --include-data-dir=sources=sources `
    --include-package="$SourcePackage" `
    --product-name="$ProductName" `
    --file-version="$ProjectVersion" `
    --file-description="A Testing Deployment From A Custom Cython Development Environment" `
    --windows-icon-from-ico="$IconPath" `
    --windows-console-mode=force `
    --report=".logs/compilation-report.xml"
if ($LASTEXITCODE -ne 0) {
    Write-Host "- Nuitka Console Deployment Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}
Write-Host "- Nuitka Console Deployment Complete" -ForegroundColor Green

# --include-data-files="settings.toml=settings.toml" `
# --include-data-files=".env=.env" `
# --include-data-files=".secrets.toml=.secrets.toml" `