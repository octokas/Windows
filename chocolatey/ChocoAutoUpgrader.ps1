# Script must be run with administrator privileges
#Requires -RunAsAdministrator

# Set window title and size
$host.UI.RawUI.WindowTitle = "Chocolatey Auto Upgrader"

# Monokai Pro-inspired colors using PowerShell console colors
$colors = @{
    Background = "Black"      # Dark background
    Foreground = "White"      # Light text
    Black      = "DarkGray"   # Dark gray
    Blue       = "Cyan"       # Cyan
    Cyan       = "Green"      # Light green
    Green      = "Green"      # Green
    Purple     = "Magenta"    # Purple
    Red        = "Red"        # Red
    White      = "White"      # White
    Yellow     = "Yellow"     # Yellow
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
    $console.BackgroundColor = [System.ConsoleColor]::Black
    $console.ForegroundColor = [System.ConsoleColor]::White

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
    Write-Host "`n=== Chocolatey Upgrade Menu ===" -ForegroundColor Magenta
    Write-Host "1. Update Chocolatey Only" -ForegroundColor Yellow
    Write-Host "2. Update All Packages" -ForegroundColor Yellow
    Write-Host "3. View Today's Logs" -ForegroundColor Yellow
    Write-Host "4. Troubleshoot Review" -ForegroundColor Yellow
    Write-Host "5. Write to Log File" -ForegroundColor Yellow
    Write-Host "6. Support Developer" -ForegroundColor Yellow
    Write-Host "Q. Quit" -ForegroundColor Red
    Write-Host "===========================" -ForegroundColor Magenta
}

# Main loop
do {
    Show-Menu
    $selection = Read-Host "Please make a selection"

    switch ($selection) {
        "1" {
            Write-Host "Updating Chocolatey Only..." -ForegroundColor Cyan
            try {
                choco upgrade chocolatey -y --verbose
            }
            catch {
                Write-Host "Error occurred: $_" -ForegroundColor Red
            }
        }
        "2" {
            Write-Host "Updating All Packages..." -ForegroundColor Cyan
            try {
                choco upgrade all -y --verbose
            }
            catch {
                Write-Host "Error occurred: $_" -ForegroundColor Red
            }
        }
        "3" {
            Write-Host "Viewing Today's Chocolatey Logs..." -ForegroundColor Cyan
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
                Write-Host "Error reading log file: $_" -ForegroundColor Red
            }
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "4" {
            Write-Host "Opening Chocolatey log file..." -ForegroundColor Cyan
            Start-Process "C:\ProgramData\chocolatey\logs\chocolatey.log"
        }
        "5" {
            Write-Host "Writing to log file..." -ForegroundColor Cyan
            $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Add-Content -Path $logFile -Value "`n=== Chocolatey Upgrade Log - $date ===`n"
        }
        "6" {
            Write-Host "`nSend at least 15 USD via Apple Cash to:" -ForegroundColor Cyan
            Write-Host "awestomates@proton.me" -ForegroundColor Yellow
            Write-Host "Thank you for supporting my caffeine addiction!`n" -ForegroundColor Cyan
            Write-Host "Press any key to continue..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
        "Q" {
            Write-Host "Session Ended." -ForegroundColor Green
            return
        }
        default {
            Write-Host "Invalid selection. Please try again." -ForegroundColor Red
        }
    }
} while ($true)
