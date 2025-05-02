$public_configurations = Get-Content .cylon/configurations/public.json -Raw | ConvertFrom-Json


function Logger {
    param (
        [Parameter(Mandatory=$true)][string]$Message,
        [ValidateSet("INFO", "SUCCESS", "WARNING", "ERROR")][string]$Level = "INFO",
        [string]$LogFile = $($public_configurations.logs.log_path)
    )

    $timestamp = Get-Date -Format $($public_configurations.logs.timestamp_format)
    $logEntry = "[$timestamp] [$Level] $Message"

    if ($public_configurations.logs.is_enabled.all -or $public_configurations.logs.is_enabled.console) {
        if ($Level -match "INFO") {
            Write-Host $logEntry -ForegroundColor Blue

        } elseif ($Level -match "SUCCESS") {
            Write-Host $logEntry -ForegroundColor Green

        } elseif ($Level -match "WARNING") {
            Write-Host $logEntry -ForegroundColor Yellow

        } elseif ($Level -match "ERROR") {
            Write-Host $logEntry -ForegroundColor Red

        } else {
            Write-Host $logEntry
        }
    }

    try {
        if ($public_configurations.logs.is_enabled.all -or $public_configurations.logs.is_enabled.file) {
            Add-Content -Path $LogFile -Value $logEntry
        }

    } catch {
        Write-Host "[ERROR] Failed to write to log file: $_"
    }
}
