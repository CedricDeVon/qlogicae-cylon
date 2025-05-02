$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
$private_configurations = Get-Content .cylon/configurations/private.json | ConvertFrom-Json
$application_configurations = Get-Content .cylon/configurations/application.json -Raw | ConvertFrom-Json
$secrets = ((Get-Content .cylon/configurations/private.json | ConvertFrom-Json).windows_registry.release.hkcu | ConvertTo-Json -Compress).Replace('{', '{{').Replace('}', '}}')
. "$($public_configurations.scripts.import_utilities)"


Write-Host "- Installment Pipeline Begins" -ForegroundColor Green

& $public_configurations.scripts.iscc `
    /DMyAppId="$($application_configurations.id)" `
    /DMyAppName="$($application_configurations.name)" `
    /DMyAppVersion="$($application_configurations.version)" `
    /DMyAppPublisher="$($application_configurations.company)" `
    /DMyAppURL="$($application_configurations.url)" `
    /DMyAppExeName="$($application_configurations.name).exe" `
    /DMyLicenseFile="$(Get-Location)\$($application_configurations.license_path)" `
    /DMyOutputBaseFilename="$($application_configurations.name)_v$($application_configurations.version)_$($public_configurations.release.windows_architecture)_Setup" `
    /DMySetupIconFile="$(Get-Location)\$($application_configurations.icon_path)" `
    /DMyOutputDir="$(Get-Location)\$($public_configurations.compilation.output_path)\$($application_configurations.name)" `
    /DMyAppExeSource="$(Get-Location)\$($public_configurations.compilation.output_path)\$($application_configurations.name)\$($application_configurations.name)\$($application_configurations.name).exe" `
    /DMyAppFolderSource="$(Get-Location)\$($public_configurations.compilation.output_path)\$($application_configurations.name)\$($application_configurations.name)\*" `
    /DMyAppSecretBaseKey="$($application_configurations.root_sub_key)" `
    /DMyAppSecretBaseDataSubKey="$($application_configurations.sub_data_key)" `
    /DMyAppHkcuSecretValues="$($secrets)" `
    $public_configurations.release.installment_template_path
if ($LASTEXITCODE) {
    Write-Host "- Installment Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "- Installment Pipeline Complete" -ForegroundColor Green
