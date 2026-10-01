$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json
$application_configurations = Get-Content .cylon/configurations/application.json -Raw | ConvertFrom-Json
. "$($public_configurations.scripts.import_utilities)"


Write-Host "- Post Compile Pipeline Begins" -ForegroundColor Green

if (powershell -NoProfile -Command "Test-Path -Path '$($public_configurations.compilation.output_path)/$($application_configurations.name)/$($application_configurations.name)'") {
    powershell -NoProfile -Command "Remove-Item -LiteralPath '$($public_configurations.compilation.output_path)/$($application_configurations.name)/$($application_configurations.name)' -Recurse -Force -ErrorAction SilentlyContinue -Confirm:`$false"
}

powershell -NoProfile -Command "Remove-Item -LiteralPath '$($public_configurations.compilation.output_path)/$($application_configurations.name)/$($public_configurations.compilation.entry_path).pyx.build' -Recurse -Force -Confirm:`$false"
if ($LASTEXITCODE) {
    Write-Host "- Post Compile Pipeline Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

powershell -NoProfile -Command "Rename-Item -Path '$($public_configurations.compilation.output_path)/$($application_configurations.name)/$($public_configurations.compilation.entry_path).pyx.dist' -NewName '$($application_configurations.name)'"
if ($LASTEXITCODE) {
    Write-Host "- Post Compile Pipeline Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

powershell -NoProfile -Command "Rename-Item -Path '$($public_configurations.compilation.output_path)/$($application_configurations.name)/$($application_configurations.name)/$($public_configurations.compilation.entry_path).pyx.exe' -NewName '$($application_configurations.name).exe'"
if ($LASTEXITCODE) {
    Write-Host "- Post Compile Pipeline Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "- Post Compile Pipeline Complete" -ForegroundColor Green
