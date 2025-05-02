$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


Write-Host "- Compilation Pipeline Begins" -ForegroundColor Green

if ($args[1] -match "console") {
    & nuitka "$($public_configurations.compilation.entry_path).pyx" `
        --standalone `
        --follow-imports `
        --lto=yes `
        --static-libpython=no `
        --assume-yes-for-downloads `
        --msvc=latest `
        --nofollow-import-to="$($public_configurations.compilation.excluded_imports -join ',')" `
        --noinclude-pytest-mode=nofollow `
        --nofollow-import-to=tkinter `
        --output-dir="$($public_configurations.compilation.output_path)/$($public_configurations.application.name)" `
        @($public_configurations.compilation.input_paths | ForEach-Object { "--include-data-dir=$_=$_" }) `
        @($public_configurations.compilation.input_file_paths | ForEach-Object { "--include-data-files=$_=$_" }) `
        --include-package="$($public_configurations.compilation.include_packages -join ',')" `
        --product-name="$($public_configurations.application.name)" `
        --file-version="$($public_configurations.application.version)" `
        --file-description="$($public_configurations.application.description)" `
        --windows-icon-from-ico="$($public_configurations.application.icon_path)" `
        --windows-console-mode=force `
        $(if ($public_configurations.compilation.request_for_windows_uac_admin_permissions) { "--windows-uac-admin" } else { "" }) `
        --report="$($public_configurations.compilation.compilation_report_path)"

} elseif ($args[1] -match "desktop") {
    & nuitka "$($public_configurations.compilation.entry_path).pyx" `
        --standalone `
        --follow-imports `
        --lto=yes `
        --static-libpython=no `
        --assume-yes-for-downloads `
        --msvc=latest `
        --nofollow-import-to="$($public_configurations.compilation.excluded_imports -join ',')" `
        --noinclude-pytest-mode=nofollow `
        --nofollow-import-to=tkinter `
        --output-dir="$($public_configurations.compilation.output_path)/$($public_configurations.application.name)" `
        @($public_configurations.compilation.input_paths | ForEach-Object { "--include-data-dir=$_=$_" }) `
        @($public_configurations.compilation.input_file_paths | ForEach-Object { "--include-data-files=$_=$_" }) `
        --include-package="$($public_configurations.compilation.include_packages -join ',')" `
        --product-name="$($public_configurations.application.name)" `
        --file-version="$($public_configurations.application.version)" `
        --file-description="$($public_configurations.application.description)" `
        --windows-icon-from-ico="$($public_configurations.application.icon_path)" `
        --windows-console-mode=disable `
        $(if ($public_configurations.compilation.request_for_windows_uac_admin_permissions) { "--windows-uac-admin" } else { "" }) `
        --report="$($public_configurations.compilation.compilation_report_path)"
} else {
    Write-Host "- Compilation Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

if ($LASTEXITCODE) {
    Write-Host "- Compilation Pipeline Phase 1 Failed" -ForegroundColor Red
    exit $LASTEXITCODE
}

& powershell -NoProfile -ExecutionPolicy Bypass -File $public_configurations.scripts.post_compile
if ($LASTEXITCODE) {
    exit $LASTEXITCODE
}

Write-Host "- Compilation Pipeline Complete" -ForegroundColor Green
