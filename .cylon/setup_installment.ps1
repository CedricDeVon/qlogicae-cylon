$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
$private_configurations = Get-Content .cylon/configurations/private.json | ConvertFrom-Json

echo "$(Get-Location)\$($public_configurations.compilation.output_path)\$($public_configurations.application.name)\$($public_configurations.application.name)\$($public_configurations.application.name).exe"
echo "$(Get-Location)\$($public_configurations.application.license_path)"
echo "$(Get-Location)\$($public_configurations.compilation.output_path)\$($public_configurations.application.name)"
echo "$(Get-Location)\$($public_configurations.application.icon_path)"
echo "$(Get-Location)\$($public_configurations.compilation.output_path)\$($public_configurations.application.name)\$($public_configurations.application.name)\*"
echo $public_configurations.release.installment_template_path

Write-Host "- Installment Pipeline Begins" -ForegroundColor Green

& $public_configurations.scripts.iscc `
    /DMyAppId="[guid]::NewGuid().ToString()" `
    /DMyAppName="$($public_configurations.application.name)" `
    /DMyAppVersion="$($public_configurations.application.version)" `
    /DMyAppPublisher="$($public_configurations.application.company)" `
    /DMyAppURL="$($public_configurations.application.url)" `
    /DMyAppExeName="$($public_configurations.application.name).exe" `
    /DMyLicenseFile="$(Get-Location)\$($public_configurations.application.license_path)" `
    /DMyOutputBaseFilename="$($public_configurations.application.name)_v$($public_configurations.application.version)_$($public_configurations.release.windows_architecture)_Setup" `
    /DMySetupIconFile="$(Get-Location)\$($public_configurations.application.icon_path)" `
    /DMyOutputDir="$(Get-Location)\$($public_configurations.compilation.output_path)\$($public_configurations.application.name)" `
    /DMyAppExeSource="$(Get-Location)\$($public_configurations.compilation.output_path)\$($public_configurations.application.name)\$($public_configurations.application.name)\$($public_configurations.application.name).exe" `
    /DMyAppFolderSource="$(Get-Location)\$($public_configurations.compilation.output_path)\$($public_configurations.application.name)\$($public_configurations.application.name)\*" `
    /DMyAppSecretBaseKey="$($public_configurations.environment.base_key)" `
    /DMyAppSecretBaseDataSubKey="$($public_configurations.environment.base_data_sub_key)" `
    /DMyAppHkcuSecretValues="$($private_configurations.windows_registry.release.hkcu)" `
    $public_configurations.release.installment_template_path
if ($LASTEXITCODE) {
    Write-Host "- Installment Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "- Installment Pipeline Complete" -ForegroundColor Green
