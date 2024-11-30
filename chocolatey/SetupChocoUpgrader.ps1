# Run this script once to set up the scheduled task
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$env:USERPROFILE\ChocoAutomations\ChocoAutoUpgrade.ps1`""
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName "ChocoAutoUpgrade" -Action $action -Trigger $trigger -Principal $principal -Settings $settings

## To Delete the scheduled task, run the following command:
## Unregister-ScheduledTask -TaskName "ChocoAutoUpgrade" -Confirm:$false
