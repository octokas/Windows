# Script must be run with administrator privileges
#Requires -RunAsAdministrator

# Create logs directory if it doesn't exist
$logPath = "$env:USERPROFILE\ChocoAutomations\ChocoLogs"
if (-not (Test-Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath | Out-Null
}

$logFile = Join-Path $logPath "ChocoUpgradeLog.md"
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Function to write to both console and log file
function Write-Log {
    param($Message)
    Write-Host $Message
    Add-Content -Path $logFile -Value $Message
}

# Start new log entry
Add-Content -Path $logFile -Value "`n## Chocolatey Upgrade Log - $date`n"

function Show-Menu {
    Write-Host "`n=== Chocolatey Upgrade Menu ===" -ForegroundColor Cyan
    Write-Host "1. Update Chocolatey Only"
    Write-Host "2. Update All Packages"
    Write-Host "Q. Quit"
    Write-Host "================================" -ForegroundColor Cyan
}

# Main loop
do {
    Show-Menu
    $selection = Read-Host "Please make a selection"

    switch ($selection) {
        '1' {
            Write-Log "### Updating Chocolatey Only`n"
            Write-Log "``````"
            try {
                $output = choco upgrade chocolatey -y --verbose | Out-String
                Write-Log $output
            }
            catch {
                Write-Log "Error occurred: $_"
            }
            Write-Log "``````n"
        }
        '2' {
            Write-Log "### Updating All Packages`n"
            Write-Log "``````"
            try {
                $output = choco upgrade all -y --verbose | Out-String
                Write-Log $output
            }
            catch {
                Write-Log "Error occurred: $_"
            }
            Write-Log "``````n"
        }
        'Q' {
            Write-Log "### Session Ended`n"
            return
        }
        default {
            Write-Host "Invalid selection. Please try again." -ForegroundColor Red
        }
    }
} while ($true)
