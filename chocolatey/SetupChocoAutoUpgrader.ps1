# Check for admin privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run as Administrator. Launching elevated prompt..." -ForegroundColor Yellow
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Set window title
$host.UI.RawUI.WindowTitle = "Chocolatey Auto Upgrader Setup"

# Create installation directory
$installPath = "$env:USERPROFILE\ChocoAutomations"
Write-Host "`n=== Chocolatey Auto Upgrader Setup ===" -ForegroundColor Magenta
Write-Host "Creating installation directory..." -ForegroundColor Cyan
if (-not (Test-Path $installPath)) {
    New-Item -ItemType Directory -Path $installPath | Out-Null
}

# Create logs directory
$logPath = Join-Path $installPath "ChocoLogs"
Write-Host "Creating logs directory..." -ForegroundColor Cyan
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

Write-Host "`nDownloading required scripts..." -ForegroundColor Cyan
foreach ($file in $files) {
    $destination = Join-Path $installPath $file.Name
    try {
        Invoke-WebRequest -Uri $file.Url -OutFile $destination
        Write-Host "Downloaded $($file.Name)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to download $($file.Name): $_" -ForegroundColor Red
        exit 1
    }
}

# Install Chocolatey if not already installed
Write-Host "`nChecking Chocolatey installation..." -ForegroundColor Cyan
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))
        Write-Host "Chocolatey installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to install Chocolatey: $_" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "Chocolatey is already installed" -ForegroundColor Green
}

# Create desktop shortcut
$shortcutPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("Desktop"), "Chocolatey Upgrader.lnk")
Write-Host "`nCreating desktop shortcut..." -ForegroundColor Cyan
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$installPath\Launch-ChocoUpgrader.ps1`""
$shortcut.WorkingDirectory = $installPath
$shortcut.IconLocation = "C:\ProgramData\chocolatey\choco.exe,0"
$shortcut.Save()

Write-Host "`n=== Installation Complete! ===" -ForegroundColor Magenta

Write-Host "`nInstallation Details:" -ForegroundColor Yellow
Write-Host "Installation Path: $installPath" -ForegroundColor White
Write-Host "Logs Directory: $logPath" -ForegroundColor White
Write-Host "Desktop Shortcut Created: $shortcutPath" -ForegroundColor White

Write-Host "`nTo get started:" -ForegroundColor Yellow
Write-Host "1. Double-click the 'Chocolatey Upgrader' shortcut on your desktop" -ForegroundColor White
Write-Host "2. The script will request admin privileges automatically" -ForegroundColor White
Write-Host "3. Use the menu to manage your Chocolatey packages" -ForegroundColor White

Write-Host "`nPress any key to exit..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
