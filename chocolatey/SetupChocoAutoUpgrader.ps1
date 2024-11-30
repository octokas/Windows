# Check for admin privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run as Administrator. Launching elevated prompt..." -ForegroundColor Yellow
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Set window title and colors for installation
$host.UI.RawUI.WindowTitle = "Chocolatey Auto Upgrader Setup"
$colors = @{
    Background = "#2D2A2E"    # Dark purple-brown background
    Foreground = "#FCFCFA"    # Light text
    Purple     = "#AB9DF2"    # Purple
    Yellow     = "#FFD866"    # Yellow
    Red        = "#FF6188"    # Red
    Green      = "#A9DC76"    # Green
    Blue       = "#78DCE8"    # Cyan
}

# Function to write styled messages
function Write-Styled {
    param(
        [string]$Message,
        [string]$Color = $colors.Foreground
    )
    Write-Host $Message -ForegroundColor $Color
}

# Create installation directory
$installPath = "$env:USERPROFILE\ChocoAutomations"
Write-Styled "`n╔════════════════════════════════════════╗" -Color $colors.Purple
Write-Styled "║     Chocolatey Auto Upgrader Setup     ║" -Color $colors.Purple
Write-Styled "╚════════════════════════════════════════╝`n" -Color $colors.Purple

Write-Styled "Creating installation directory..." -Color $colors.Blue
if (-not (Test-Path $installPath)) {
    New-Item -ItemType Directory -Path $installPath | Out-Null
}

# Create logs directory
$logPath = Join-Path $installPath "ChocoLogs"
Write-Styled "Creating logs directory..." -Color $colors.Blue
if (-not (Test-Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath | Out-Null
}

# Download required scripts
$files = @(
    @{
        Name = "ChocoAutoUpgrader.ps1"
        Url = "https://raw.githubusercontent.com/yourusername/repo/main/chocolatey/ChocoAutoUpgrader.ps1"
    },
    @{
        Name = "Launch-ChocoUpgrader.ps1"
        Url = "https://raw.githubusercontent.com/yourusername/repo/main/chocolatey/Launch-ChocoUpgrader.ps1"
    }
)

Write-Styled "`nDownloading required scripts..." -Color $colors.Blue
foreach ($file in $files) {
    $destination = Join-Path $installPath $file.Name
    try {
        Invoke-WebRequest -Uri $file.Url -OutFile $destination
        Write-Styled "Downloaded $($file.Name)" -Color $colors.Green
    }
    catch {
        Write-Styled "Failed to download $($file.Name): $_" -Color $colors.Red
        exit 1
    }
}

# Install Chocolatey if not already installed
Write-Styled "`nChecking Chocolatey installation..." -Color $colors.Blue
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Styled "Installing Chocolatey..." -Color $colors.Yellow
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Write-Styled "Chocolatey installed successfully!" -Color $colors.Green
    }
    catch {
        Write-Styled "Failed to install Chocolatey: $_" -Color $colors.Red
        exit 1
    }
}
else {
    Write-Styled "Chocolatey is already installed" -Color $colors.Green
}

# Create desktop shortcut
$shortcutPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "Chocolatey Upgrader.lnk")
Write-Styled "`nCreating desktop shortcut..." -Color $colors.Blue
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$installPath\Launch-ChocoUpgrader.ps1`""
$shortcut.WorkingDirectory = $installPath
$shortcut.IconLocation = "C:\ProgramData\chocolatey\choco.exe,0"
$shortcut.Save()

Write-Styled "`n╔════════════════════════════════════════╗" -Color $colors.Purple
Write-Styled "║        Installation Complete!         ║" -Color $colors.Purple
Write-Styled "╚════════════════════════════════════════╝" -Color $colors.Purple

Write-Styled "`nInstallation Details:" -Color $colors.Yellow
Write-Styled "Installation Path: $installPath" -Color $colors.Foreground
Write-Styled "Logs Directory: $logPath" -Color $colors.Foreground
Write-Styled "Desktop Shortcut Created: $shortcutPath" -Color $colors.Foreground

Write-Styled "`nTo get started:" -Color $colors.Yellow
Write-Styled "1. Double-click the 'Chocolatey Upgrader' shortcut on your desktop" -Color $colors.Foreground
Write-Styled "2. The script will request admin privileges automatically" -Color $colors.Foreground
Write-Styled "3. Use the menu to manage your Chocolatey packages" -Color $colors.Foreground

Write-Styled "`nPress any key to exit..." -Color $colors.Blue
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
