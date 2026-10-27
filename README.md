# Claude Dual-CLI (Windows)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Platform: Windows](https://img.shields.io/badge/platform-Windows-0078D6)
![PowerShell 5.1 | 7+](https://img.shields.io/badge/PowerShell-5.1%20%7C%207%2B-5391FE)

**English** | [繁體中文](README.zh-TW.md)

Run two Claude Code CLI sessions side by side on one Windows machine, each signed in to its own account and keeping its own settings and history.

Typical uses:

- Keep **work** and **personal** accounts apart on the same computer
- Give two parallel tasks (for example a frontend task and a backend task) **separate contexts and settings**
- Try a new setting or MCP server in a **throwaway profile** without touching your main one

> **Please read:** use only accounts you own, and follow [Anthropic's terms and usage policies](https://www.anthropic.com/legal). This project only keeps two profiles apart; it does not change any account's usage limits.

![How it works](docs/images/how-it-works.svg)

## How it works

Claude Code stores its sign-in, settings and history in a config folder. The `CLAUDE_CONFIG_DIR` environment variable tells it which folder to use.

The scripts in this repo set that variable **only inside a new PowerShell process**. Your usual terminal is not affected and keeps the default profile.

## Requirements

- Windows 10 or 11
- Windows PowerShell 5.1 or PowerShell 7+
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed, with `claude` available in `PATH`
- A second account you can sign in with

## Quick start

![Setup steps](docs/images/setup-steps.svg)

```powershell
git clone https://github.com/sss40914/Claude-Dual-CLI.git
cd Claude-Dual-CLI

# If script execution is blocked, allow it for this window only:
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# 1. Create the second profile and sign in (once)
.\scripts\Setup-ClaudeProfile.ps1

# 2. Open Claude Code with that profile in a new window
.\scripts\Start-ClaudeProfile.ps1
```

Then keep using `claude` in your usual terminal for the default profile.

## Script reference

### `Setup-ClaudeProfile.ps1`

| Parameter | Default | Description |
|---|---|---|
| `-Name` | `secondary` | Profile name. The folder becomes `%USERPROFILE%\.claude-<Name>` |

Creates the folder, runs `claude auth login` with that folder, then prints `claude auth status` so you can confirm which account is signed in.

### `Start-ClaudeProfile.ps1`

| Parameter | Default | Description |
|---|---|---|
| `-Name` | `secondary` | Which profile to open |
| `-ProjectPath` | current folder | Folder to open Claude Code in |
| `-SameWindow` | off | Run in the current terminal instead of a new window |
| `-DryRun` | off | Print what would run, start nothing |

The new window title is `Claude Code [<Name>]`, so you can tell the windows apart.

## Examples

```powershell
# A "work" profile opened in a specific project
.\scripts\Setup-ClaudeProfile.ps1 -Name work
.\scripts\Start-ClaudeProfile.ps1 -Name work -ProjectPath D:\code\api

# Check which account a profile is using
$env:CLAUDE_CONFIG_DIR = "$HOME\.claude-work"; claude auth status; Remove-Item Env:CLAUDE_CONFIG_DIR
```

More recipes, including a Windows Terminal profile, are in [`examples/`](examples/).

## Good to know

- **Each profile keeps its own user-level data.** Sign-in, user settings, user-level MCP servers and history are not shared; copy any user settings you need into the new folder. Files that live in the project itself (such as `CLAUDE.md`, `.claude/settings.json` or `.mcp.json`) are still shared, because both windows open the same project.
- **Starting from inside Claude Code.** If you run the script from a terminal that Claude Code itself opened, that terminal carries session variables. The scripts detect this and drop them in the new window so the new session starts clean.
- **Removing a profile.** Sign out first (`claude auth logout` with that profile), then delete the `.claude-<Name>` folder.
- **Keep the folders private.** They hold sign-in data. Do not commit or share them; `.gitignore` here already excludes `.claude*/`.

## Troubleshooting

See [docs/troubleshooting.md](docs/troubleshooting.md).

## Contributing

Issues and pull requests are welcome. Please describe your Windows and PowerShell versions, and never paste tokens or the contents of a profile folder.

## License

[MIT](LICENSE)
