# 疑難排解

[English](troubleshooting.md) | **繁體中文**

## 出現「這個系統已停用指令碼執行」

Windows 預設擋住未簽章的腳本。只對目前這個視窗放行：

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

關掉視窗就失效，不會改到整台電腦的設定。

## 出現 `"claude" was not found in PATH`

安裝 Claude Code 後請開一個新的終端機，再確認：

```powershell
Get-Command claude
```

找不到的話，重新安裝 Claude Code，或把它的安裝資料夾加進 `PATH`。

## 兩個視窗登入的是同一個帳號

1. 在新視窗確認目前用哪組設定：
   ```powershell
   $env:CLAUDE_CONFIG_DIR
   claude auth status
   ```
2. `CLAUDE_CONFIG_DIR` 是空的：這個視窗不是用 `Start-ClaudeProfile.ps1` 開的。
3. 有值但帳號不對：用 `Setup-ClaudeProfile.ps1 -Name <名稱>` 重新登入。

## 從 Claude Code 裡面開新視窗，行為怪怪的

Claude Code 自己開的終端機帶有工作階段變數（`CLAUDECODE`、`CLAUDE_CODE_*` 等）。新的工作階段繼承到這些變數，可能會以為自己是子工作階段，例如不儲存對話紀錄。

腳本偵測到 `CLAUDECODE` 時會在新視窗清掉這些變數。如果你用其他方式在工作階段裡啟動 Claude Code，請先自己清掉：

```powershell
Get-ChildItem Env: | Where-Object { $_.Name -like 'CLAUDE*' -and $_.Name -ne 'CLAUDE_CONFIG_DIR' } |
    ForEach-Object { Remove-Item "Env:$($_.Name)" }
```

## 主控台出現亂碼

腳本只輸出英文與符號，在 Windows PowerShell 5.1 也能正常顯示。如果你在腳本裡加了中文訊息，請存成 **UTF-8 with BOM**；Windows PowerShell 5.1 讀沒有 BOM 的檔案會用系統字碼頁，中文就會變亂碼。

## 某個設定在一個視窗有效、另一個沒有

這是正常的：每組設定有自己的使用者設定。把 `settings.json`（或其他需要的檔案）從一個設定資料夾複製到另一個，或把共用設定放在專案的 `.claude/settings.json`，兩個視窗都會讀到。
