$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


Write-Host "- Console Deployment Pipeline Begins" -ForegroundColor Green

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
        --include-package="$($public_configurations.compilation.include_packages -join ',')" `
        --product-name="$($public_configurations.application.name)" `
        --file-version="$($public_configurations.application.version)" `
        --file-description="$($public_configurations.application.description)" `
        --windows-icon-from-ico="$($public_configurations.application.icon_path)" `
        --windows-console-mode=force `
        $(if ($public_configurations.compilation.windows_uac_admin) { "--windows-uac-admin" } else { "" }) `
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
        --include-package="$($public_configurations.compilation.include_packages -join ',')" `
        --product-name="$($public_configurations.application.name)" `
        --file-version="$($public_configurations.application.version)" `
        --file-description="$($public_configurations.application.description)" `
        --windows-icon-from-ico="$($public_configurations.application.icon_path)" `
        --windows-console-mode=disable `
        $(if ($public_configurations.compilation.windows_uac_admin) { "--windows-uac-admin" } else { "" }) `
        --report="$($public_configurations.compilation.compilation_report_path)"
} else {
    Write-Host "- Console Deployment Pipeline Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

if ($LASTEXITCODE) {
    Write-Host "- Console Deployment Pipeline Failed" -ForegroundColor Red
    Pause
    exit $LASTEXITCODE
}

Write-Host "- Console Deployment Pipeline Complete" -ForegroundColor Green
