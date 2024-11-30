# This script sets up an automated task in Windows Task Scheduler

# Create a new task that will:
# 1. Run PowerShell
# 2. Allow it to run scripts
# 3. Run our upgrade script
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$env:USERPROFILE\choco-auto-upgrade.ps1`""

# Set when the task should run
# In this case, it's set to run when you log into Windows
$trigger = New-ScheduledTaskTrigger -AtLogOn

# Set up who runs the task and what permissions it needs
# It will run as your user account with admin rights
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest

# Configure additional settings:
# - Allow the task to run on battery power
# - Don't stop the task if computer switches to battery
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

# Finally, register this as a new task in Windows Task Scheduler
# with all the settings we defined above
Register-ScheduledTask -TaskName "ChocoAutoUpgrade" -Action $action -Trigger $trigger -Principal $principal -Settings $settings
