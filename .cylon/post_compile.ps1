$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


Write-Host "- Post Compile Pipeline Begins" -ForegroundColor Green

if (powershell -NoProfile -Command "Test-Path -Path '$($public_configurations.compilation.output_path)/$($public_configurations.application.name)/$($public_configurations.application.name)'") {
    powershell -NoProfile -Command "Remove-Item -LiteralPath '$($public_configurations.compilation.output_path)/$($public_configurations.application.name)/$($public_configurations.application.name)' -Recurse -Force -ErrorAction SilentlyContinue -Confirm:`$false"
}

powershell -NoProfile -Command "Remove-Item -LiteralPath '$($public_configurations.compilation.output_path)/$($public_configurations.application.name)/$($public_configurations.compilation.entry_path).pyx.build' -Recurse -Force -Confirm:`$false"
if ($LASTEXITCODE) {
    Write-Host "- Post Compile Pipeline Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

powershell -NoProfile -Command "Rename-Item -Path '$($public_configurations.compilation.output_path)/$($public_configurations.application.name)/$($public_configurations.compilation.entry_path).pyx.dist' -NewName '$($public_configurations.application.name)'"
if ($LASTEXITCODE) {
    Write-Host "- Post Compile Pipeline Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

powershell -NoProfile -Command "Rename-Item -Path '$($public_configurations.compilation.output_path)/$($public_configurations.application.name)/$($public_configurations.application.name)/$($public_configurations.compilation.entry_path).pyx.exe' -NewName '$($public_configurations.application.name).exe'"
if ($LASTEXITCODE) {
    Write-Host "- Post Compile Pipeline Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "- Post Compile Pipeline Complete" -ForegroundColor Green
