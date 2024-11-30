# Find the .git directory by walking up the directory tree
function Find-GitRoot {
    $currentPath = Get-Location
    while ($currentPath -ne "") {
        $gitPath = Join-Path $currentPath ".git"
        if (Test-Path $gitPath) {
            return $gitPath
        }
        $parentPath = Split-Path $currentPath -Parent
        if ($parentPath -eq $currentPath) {
            # We've reached the root
            break
        }
        $currentPath = $parentPath
    }
    return $null
}

# Get the Git directory
$gitDir = Find-GitRoot
if (-not $gitDir) {
    Write-Host "Error: Not a git repository (or any of the parent directories)" -ForegroundColor Red
    exit 1
}

# Create the hooks directory
$hooksPath = Join-Path $gitDir "hooks"
if (-not (Test-Path $hooksPath)) {
    New-Item -ItemType Directory -Path $hooksPath -Force | Out-Null
}

# Create the post-merge hook file
$postMergePath = Join-Path $hooksPath "post-merge"
$hookContent = @'
#!/bin/sh
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "./chocolatey/Update-ChocoScripts.ps1"
'@

$hookContent | Out-File -FilePath $postMergePath -Encoding ASCII -Force

Write-Host "Git post-merge hook has been created at: $postMergePath" -ForegroundColor Green
Write-Host "Hook will run Update-ChocoScripts.ps1 after each git pull" -ForegroundColor Cyan
