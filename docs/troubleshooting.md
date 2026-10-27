# Troubleshooting

**English** | [繁體中文](troubleshooting.zh-TW.md)

## "running scripts is disabled on this system"

Windows blocks unsigned scripts by default. Allow them for the current window only:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

This lasts until you close the window and does not change the machine-wide policy.

## `"claude" was not found in PATH`

Open a new terminal after installing Claude Code, then check:

```powershell
Get-Command claude
```

If nothing is found, reinstall Claude Code or add its install folder to `PATH`.

## Both windows show the same account

1. Check the profile in the new window:
   ```powershell
   $env:CLAUDE_CONFIG_DIR
   claude auth status
   ```
2. If `CLAUDE_CONFIG_DIR` is empty, the window was not started by `Start-ClaudeProfile.ps1`.
3. If it is set but shows the wrong account, sign in again with `Setup-ClaudeProfile.ps1 -Name <Name>`.

## The new window behaves oddly when started from inside Claude Code

A terminal opened by Claude Code carries session variables (`CLAUDECODE`, `CLAUDE_CODE_*` and similar). A new session that inherits them may think it is a child session, for example by not saving its history.

The scripts remove these variables in the new window when they detect `CLAUDECODE`. If you start Claude Code some other way from inside a session, clear them yourself first:

```powershell
Get-ChildItem Env: | Where-Object { $_.Name -like 'CLAUDE*' -and $_.Name -ne 'CLAUDE_CONFIG_DIR' } |
    ForEach-Object { Remove-Item "Env:$($_.Name)" }
```

## Garbled characters in the console

The scripts print plain ASCII only, so they display correctly in Windows PowerShell 5.1 as well. If you add your own messages in other languages, save the file as **UTF-8 with BOM**; Windows PowerShell 5.1 reads files without a BOM using the system code page.

## A setting works in one window but not the other

That is expected: each profile has its own user settings. Copy `settings.json` (and anything else you need) from one profile folder to the other, or put shared settings in the project's `.claude/settings.json`, which both windows read.
