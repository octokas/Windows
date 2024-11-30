### Author: Octokas, https://github.com/octokas
### Date: 2024-11-30
### Description: PowerShell profile for Windows
### Version: 1.8.0

#Requires -RunAsAdministrator

## Ubuntu-Like Window Settings
# Monokai Pro-like colors
$Host.UI.RawUI.BackgroundColor = '#2D2A2E'
$Host.UI.RawUI.ForegroundColor = 'Gray'

# Configure PSReadLine colors
Set-PSReadLineOption -Colors @{
    Command            = '#A6E22E'
    Parameter         = '#FD971F'
    Operator          = '#F92672'
    Variable          = '#66D9EF'
    String            = '#E6DB74'
    Number            = '#AE81FF'
    Type              = '#66D9EF'
    Comment           = '#75715E'
}

# Ubuntu-like prompt function
function prompt {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

    $prefix = ""
    if($principal.IsInRole($adminRole)) {
        $prefix = "[ADMIN] "
    }

    $location = $(Get-Location).Path.Replace($HOME, "~")
    $userPrompt = "$env:USERNAME@$env:COMPUTERNAME"

    Write-Host "$prefix" -NoNewline -ForegroundColor Red
    Write-Host "$userPrompt" -NoNewline -ForegroundColor Green
    Write-Host ":" -NoNewline -ForegroundColor White
    Write-Host "$location" -NoNewline -ForegroundColor Blue
    Write-Host "$" -NoNewline -ForegroundColor White
    return " "
}

# Clear the screen to apply new colors
Clear-Host

## Session Transcripts
if (-not (Test-Path "$HOME\PShellSessions")) {
    New-Item -ItemType Directory -Path "$HOME\PShellSessions" -Force
}
Start-Transcript -Path "$HOME\PShellSessions\PSSession_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').txt"
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Import Chocolatey Auto Upgrader
Import-Module "$HOME\chocolatey\ChocoAutoUpgrader.psm1"
