# This line tells Windows that this script must be run with administrator rights
# (like when you "Run as Administrator")
#Requires -RunAsAdministrator

# This section creates a folder called "choco-logs" in your main user folder
# (like C:\Users\YourName\choco-logs)
# The if (-not...) check means "if this folder doesn't exist yet"
$logPath = "$env:USERPROFILE\choco-logs"
if (-not (Test-Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath | Out-Null
}

# This creates the full path to our log file and gets the current date/time
# The log file will be called "choco-upgrade-log.md" inside the choco-logs folder
$logFile = Join-Path $logPath "choco-upgrade-log.md"
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# This is a helper function that writes messages both to:
# 1. The PowerShell window (so you can see what's happening)
# 2. The log file (so you can review it later)
function Write-Log {
    param($Message)
    Write-Host $Message
    Add-Content -Path $logFile -Value $Message
}

# This adds a new section to our log file with the current date/time
# The markdown formatting (##) makes it show up as a heading in the log
Add-Content -Path $logFile -Value "`n## Chocolatey Upgrade Log - $date`n"

# This function creates the menu you'll see when running the script
# The -ForegroundColor Cyan makes the borders show up in light blue
function Show-Menu {
    Write-Host "`n=== Chocolatey Upgrade Menu ===" -ForegroundColor Cyan
    Write-Host "1. Update Chocolatey Only"
    Write-Host "2. Update All Packages"
    Write-Host "Q. Quit"
    Write-Host "================================" -ForegroundColor Cyan
}

# This is the main part of the script that runs in a loop until you quit
do {
    # Show the menu and wait for user input
    Show-Menu
    $selection = Read-Host "Please make a selection"

    # This checks what option you picked and runs the appropriate command
    switch ($selection) {
        '1' {
            # Option 1: Update only Chocolatey itself
            Write-Log "### Updating Chocolatey Only`n"
            Write-Log "```"
            try {
                # The -y means "yes to all prompts"
                # --verbose means "show all details"
                $output = choco upgrade chocolatey -y --verbose | Out-String
                Write-Log $output
            }
            catch {
                # If something goes wrong, log the error
                Write-Log "Error occurred: $_"
            }
            Write-Log "````n"
        }
        '2' {
            # Option 2: Update all installed packages
            Write-Log "### Updating All Packages`n"
            Write-Log "```"
            try {
                # Same as above but updates everything
                $output = choco upgrade all -y --verbose | Out-String
                Write-Log $output
            }
            catch {
                Write-Log "Error occurred: $_"
            }
            Write-Log "````n"
        }
        'Q' {
            # Option Q: Exit the script
            Write-Log "### Session Ended`n"
            return
        }
        default {
            # If you type anything else, show error in red
            Write-Host "Invalid selection. Please try again." -ForegroundColor Red
        }
    }
} while ($true)
