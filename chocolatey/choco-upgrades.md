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
1. Save both files to your computer, in your user folder _(if you choose to save in a different folder, you'll have to update both scripts with their paths)_
2. Run the [`setup-choco-task.ps1`](drafts/SetupChocoUpgrader.ps1) script once as administrator _(i.e. `& ./setup-choco-task.ps1`)_
3. This creates an [automatic task in Windows](https://learn.microsoft.com/en-us/windows/win32/taskschd/task-scheduler-start-a-task-on-a-schedule?redirectedfrom=MSDN) that can run the main script

#### Regular Use:
1. Double-click the [`choco-auto-upgrade.ps1`](drafts/ChocoAutoUpgrader.ps1) script
2. Or find **"ChocoAutoUpgrade"** in Task Scheduler to run it
3. You'll see a [menu with options](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/write-host?view=powershell-7.4)
4. Pick `option 1` to update just [Chocolatey](https://chocolatey.org/)
5. Pick `option 2` to [update all your installed packages](https://docs.chocolatey.org/en-us/choco/commands/upgrade)
6. Pick `Q` to quit

#### Finding the Logs:
1. Go to your user folder _(usually `C:\Users\YourName`)_
2. Look for the **"choco-logs"** folder
3. Open **"choco-upgrade-log.md"** to see what happened
4. The log file uses markdown formatting, so it looks best when viewed in a markdown reader

#### The log file will be formatted in markdown with:
- Date/time headers for each session
- Code blocks for the output
- Error messages if any occur

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
- If you need additional help, you can run the scripts I've made for you in the [`with-annotations` directory](drafts/with-annotations) in the Powershell Editor, VS Code, or any other IDE supporting powershell scripts
- You can find more information on the [Chocolatey](https://chocolatey.org/) website and the [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/overview) documentation

---
