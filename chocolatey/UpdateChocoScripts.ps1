# Check for admin privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Define paths
$sourcePath = $PSScriptRoot  # Current directory containing the PS1 files
$destinationPath = "$env:USERPROFILE\ChocoAutomations"

# Create destination directory if it doesn't exist
if (-not (Test-Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
    Write-Host "Created destination directory: $destinationPath" -ForegroundColor Green
}

# Copy all PS1 files from source to destination
Get-ChildItem -Path $sourcePath -Filter "*.ps1" | ForEach-Object {
    try {
        Copy-Item -Path $_.FullName -Destination $destinationPath -Force
        Write-Host "Successfully updated: $($_.Name)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to copy $($_.Name): $_" -ForegroundColor Red
    }
}

Write-Host "`nScript update complete!" -ForegroundColor Cyan
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
