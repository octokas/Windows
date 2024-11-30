# Script must be run with administrator privileges
#Requires -RunAsAdministrator

# Create logs directory if it doesn't exist
$logPath = "$env:USERPROFILE\ChocoAutomations\ChocoLogs"
if (-not (Test-Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath | Out-Null
}

$logFile = Join-Path $logPath "ChocoUpgradeLog.log"
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Function to write to both console and log file
function Write-Log {
    param($Message)
    Write-Host $Message
    Add-Content -Path $logFile -Value $Message
}

# Start new log entry
Add-Content -Path $logFile -Value "`n=== Chocolatey Upgrade Log - $date ===`n"

function Show-Menu {
    Write-Host "`n=== Chocolatey Upgrade Menu ===" -ForegroundColor Cyan
    Write-Host "1. Update Chocolatey Only"
    Write-Host "2. Update All Packages"
    Write-Host "3. Update Chocolatey and All Packages"
    Write-Host "4. Troubleshoot Review with Today's Chocolatey Logs"
    Write-Host "5. Write to Your Chocolatey Auto Upgrade Log File"
    Write-Host "Q. Quit"
    Write-Host "================================" -ForegroundColor Cyan
}

# Main loop
do {
    Show-Menu
    $selection = Read-Host "Please make a selection"

    switch ($selection) {
        '1' {
            Write-Log "Updating Chocolatey Only..."
            try {
                $output = choco upgrade chocolatey -y --verbose | Out-String
                Write-Log $output
            }
            catch {
                Write-Log "Error occurred: $_"
            }
            Write-Log "`n----------------------------------------`n"
        }
        '2' {
            Write-Log "Updating All Packages..."
            try {
                $output = choco upgrade all -y --verbose | Out-String
                Write-Log $output
            }
            catch {
                Write-Log "Error occurred: $_"
            }
            Write-Log "`n----------------------------------------`n"
        }
        '3' {
            Write-Log "Updating Chocolatey and All Packages..."
            try {
                $output = choco upgrade chocolatey -y --verbose | Out-String
                Write-Log $output
                $output = choco upgrade all -y --verbose | Out-String
                Write-Log $output
            }
            catch {
                Write-Log "Error occurred: $_"
            }
            Write-Log "`n----------------------------------------`n"
        }
        '4' {
            Write-Log "Troubleshoot Review with Today's Chocolatey Logs..." -ForegroundColor Cyan
            #Write-Host "Opening $logFile..."
            #Start-Process $logFile
            try {
                $today = (Get-Date).Date
                Get-Content "C:\ProgramData\chocolatey\logs\chocolatey.log" | Where-Object {
                    if ($_ -match '^\d{4}-\d{2}-\d{2}') {
                        try {
                            $logDate = [DateTime]::ParseExact($Matches[0], "yyyy-MM-dd", $null).Date
                            $logDate -eq $today
                        } catch {
                            $false
                        }
                    }
                } | Format-Table -Wrap
            }
            catch {
                Write-Log "Error reading log file: $_" -ForegroundColor Red
            }
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        }
        '5' {
            Write-Log "Writing to Your Chocolatey Auto Upgrade Log File..." -ForegroundColor Cyan
            Add-Content -Path $logFile -Value "`n=== Chocolatey Upgrade Log - $date ===`n"
            Write-Log "`n=== Chocolatey Upgrade Log - $date ===`n"
        }
        'Q' {
            Write-Host "Session Ended."
            return
        }
        default {
            Write-Host "Invalid selection. Please try again." -ForegroundColor Red
        }
    }
} while ($true)
