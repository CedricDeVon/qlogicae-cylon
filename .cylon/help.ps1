$CONFIGURATIONS = Get-Content .cylon/configurations.json -Raw | ConvertFrom-Json

Write-Host "Cylon Commands: " -ForegroundColor Blue
Write-Host "" -ForegroundColor Blue
Write-Host "./cylon help" -ForegroundColor Blue
Write-Host "./cylon build" -ForegroundColor Blue
Write-Host "./cylon test" -ForegroundColor Blue
Write-Host "./cylon deploy" -ForegroundColor Blue
Write-Host "./cylon package-sizes [package-name-1] ... [package-name-n]" -ForegroundColor Blue


