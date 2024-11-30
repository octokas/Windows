## Chocolatey Upgrade Scripts & Logs
---
_Simple guide to using the [Chocolatey](https://chocolatey.org/) upgrade scripts in [PowerShell](https://learn.microsoft.com/en-us/powershell/), on [Windows](https://www.microsoft.com/en-us/windows)._

### Pre-Requisites
- `choco` or chocolatey
- `git`
- `gh` or GitHub CLI
- `pwshell` or PowerShell

#### Nice to Haves...
- `choco install psutils -A`

### How to Use These Scripts:
#### First Time Setup:
1. From this directory, run a `git pull` to get the latest version
2. Then run [`Setup-GitHook.ps1`](Setup-GitHook.ps1) to set up the post-merge hook
3. Copy the [Setup](SetupChocoAutoUpgrader.ps1), [`ChocoAutoUpgrader.ps1`](ChocoAutoUpgrader.ps1), and [Launch](Launch-ChocoUpgrader.ps1) scripts to your user folder _(usually `C:\Users\YourName\ChocoAutomations`)_
4. Run [`SetupChocoAutoUpgrader.ps1`](SetupChocoAutoUpgrader.ps1) to install the scheduled task
5. Double-click the [`Launch-ChocoUpgrader.ps1`](Launch-ChocoUpgrader.ps1) script to test it
6. You should see a shortcut to the [`ChocoAutoUpgrader.ps1`](ChocoAutoUpgrader.ps1) script on your desktop
7. Double-click the shortcut to test it
8. You should see a menu with options
9. Pick `option 6` to send me some caffeine money
10. Pick `Q` to quit

#### Regular Use:
> coming soon...

#### Finding the Logs:
> coming soon...


#### Key features:
- Requires **administrator privileges** automatically
- Runs with `stored credentials` via scheduled task
- [Verbose output](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_output_and_message_tracing?view=powershell-7.4)
- Markdown formatted logs
- `Yes` [execution policy](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.4) enabled by default
- Menu-driven interface
- Error handling

_To run the script manually, `right-click` it and select **"Run with PowerShell as Administrator"** or run it from an elevated `PowerShell` prompt_

### Notes
- This assumes you already have Chocolatey installed. If you don't, you'll need to install it first.
- These scripts are designed to be run with administrator privileges
- The scheduled task will run the script with the credentials of the user that created it, not the user that is logged in when the task runs
- If you want to run the script as a different user, you can change the **"Run as user"** option in the Task Scheduler
- You can find more information on the [Chocolatey](https://chocolatey.org/) website and the [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/overview) documentation

---
