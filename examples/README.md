# Examples / 範例

## 1. Windows Terminal profile / Windows Terminal 設定檔

[`windows-terminal-profile.json`](windows-terminal-profile.json) adds a "Claude (secondary)" entry to the Windows Terminal dropdown.

1. Open Windows Terminal, press `Ctrl+Shift+,` to open `settings.json`.
2. Paste the object into the `profiles.list` array.
3. Replace `C:\\path\\to\\your\\project` with your project folder.

把 [`windows-terminal-profile.json`](windows-terminal-profile.json) 的內容貼進 Windows Terminal 的 `settings.json` → `profiles.list`，下拉選單就會多一個「Claude (secondary)」。記得把專案路徑換成你自己的。

## 2. Desktop shortcut / 桌面捷徑

[`create-desktop-shortcut.ps1`](create-desktop-shortcut.ps1) creates a desktop shortcut that opens a profile in a project folder.

```powershell
.\examples\create-desktop-shortcut.ps1 -Name secondary -ProjectPath D:\code\api
```

建立一個桌面捷徑，點兩下就用指定設定開在指定專案。

## 3. Several profiles / 多組設定

```powershell
.\scripts\Setup-ClaudeProfile.ps1 -Name work
.\scripts\Setup-ClaudeProfile.ps1 -Name sandbox

.\scripts\Start-ClaudeProfile.ps1 -Name work    -ProjectPath D:\code\api
.\scripts\Start-ClaudeProfile.ps1 -Name sandbox -ProjectPath D:\scratch
```

`sandbox` is handy for trying new settings or MCP servers without touching your main setup.
`sandbox` 適合拿來試新設定或新的 MCP server，不影響主要環境。
