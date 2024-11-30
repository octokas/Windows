# Create the hooks directory if it doesn't exist
$hooksPath = ".git/hooks"
if (-not (Test-Path $hooksPath)) {
    New-Item -ItemType Directory -Path $hooksPath -Force | Out-Null
}

# Create the post-merge hook file
$hookContent = @'
#!/bin/sh
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "./chocolatey/Update-ChocoScripts.ps1"
'@

$hookContent | Out-File -FilePath ".git/hooks/post-merge" -Encoding ASCII -Force

Write-Host "Git post-merge hook has been created successfully!" -ForegroundColor Green
