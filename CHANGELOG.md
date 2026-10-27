# Changelog

## 2.0.0 - 2026-10-27

- Scripts renamed and moved to `scripts/`: `Setup-ClaudeProfile.ps1`, `Start-ClaudeProfile.ps1`
- Named profiles (`-Name`), project folder (`-ProjectPath`), `-SameWindow` and `-DryRun`
- Sign-in uses `claude auth login` and shows `claude auth status` afterwards
- Session variables inherited from a running Claude Code session are cleared in the new window
- Script output is ASCII only, so it displays correctly in Windows PowerShell 5.1
- Paths with apostrophes are handled
- English and Traditional Chinese README, troubleshooting guide, diagrams and examples

## 1.0.0 - 2026-06-15

- First release
