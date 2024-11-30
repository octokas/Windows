# Script must be run with administrator privileges
#Requires -RunAsAdministrator

# Set window title and size
$host.UI.RawUI.WindowTitle = "Chocolatey Auto Upgrader"

# Monokai Pro-inspired colors
$colors = @{
    Background = "#2D2A2E"    # Dark purple-brown background
    Foreground = "#FCFCFA"    # Light text
    Black      = "#403E41"    # Dark gray
    Blue       = "#78DCE8"    # Cyan
    Cyan       = "#A9DC76"    # Light green
    Green      = "#A9DC76"    # Green
    Purple     = "#AB9DF2"    # Purple
    Red        = "#FF6188"    # Red
    White      = "#FCFCFA"    # White
    Yellow     = "#FFD866"    # Yellow
}

# Function to set console colors
function Set-ConsoleStyle {
    # Set buffer and window size
    $width = 120
    $height = 30
    $bufferHeight = 3000

    $console = $host.UI.RawUI
    $buffer = $console.BufferSize
    $window = $console.WindowSize

    # Set buffer size first (must be larger than window)
    $buffer.Width = $width
    $buffer.Height = $bufferHeight
    $console.BufferSize = $buffer

    # Then set window size
    $window.Width = $width
    $window.Height = $height
    $console.WindowSize = $window

    # Set colors
    $console.BackgroundColor = $colors.Background
    $console.ForegroundColor = $colors.Foreground

    # Clear the screen to apply new background
    Clear-Host
}

# Apply console styling
Set-ConsoleStyle

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
    Write-Host "`n╔════════════════════════════════╗" -ForegroundColor $colors.Purple
    Write-Host "║    Chocolatey Upgrade Menu     ║" -ForegroundColor $colors.Purple
    Write-Host "╠════════════════════════════════╣" -ForegroundColor $colors.Purple
    Write-Host "║ 1. Update Chocolatey Only      ║" -ForegroundColor $colors.Yellow
    Write-Host "║ 2. Update All Packages         ║" -ForegroundColor $colors.Yellow
    Write-Host "║ 3. View Today's Logs           ║" -ForegroundColor $colors.Yellow
    Write-Host "║ 4. Troubleshoot Review         ║" -ForegroundColor $colors.Yellow
    Write-Host "║ 5. Write to Log File           ║" -ForegroundColor $colors.Yellow
    Write-Host "║ 6. Support Developer        ║" -ForegroundColor $colors.Yellow
    Write-Host "║ Q. Quit                        ║" -ForegroundColor $colors.Red
    Write-Host "╚════════════════════════════════╝" -ForegroundColor $colors.Purple
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
                Write-Log "Error occurred: $_" -ForegroundColor $colors.Red
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
                Write-Log "Error occurred: $_" -ForegroundColor $colors.Red
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
                Write-Log "Error occurred: $_" -ForegroundColor $colors.Red
            }
            Write-Log "`n----------------------------------------`n"
        }
        '4' {
            Write-Log "Troubleshoot Review with Today's Chocolatey Logs..." -ForegroundColor $colors.Blue
            Write-Host "Opening $logFile..."
            Start-Process $logFile
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
                Write-Log "Error reading log file: $_" -ForegroundColor $colors.Red
            }
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        }
        '5' {
            Write-Log "Writing to Your Chocolatey Auto Upgrade Log File..." -ForegroundColor $colors.Blue
            Add-Content -Path $logFile -Value "`n=== Chocolatey Upgrade Log - $date ===`n"
            Write-Log "`n=== Chocolatey Upgrade Log - $date ===`n"
        }
        '6' {
            Write-Host "`nSend at least 15 USD via Apple Cash to:" -ForegroundColor $colors.Yellow
            Write-Host "awestomates@proton.me" -ForegroundColor $colors.Yellow
            Write-Host "Thank you for supporting my caffeine addiction!`n" -ForegroundColor $colors.Yellow

            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        }
        'Q' {
            Write-Host "Session Ended."
            return
        }
        default {
            Write-Host "Invalid selection. Please try again." -ForegroundColor $colors.Red
        }
    }
} while ($true)
