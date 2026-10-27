<#
.SYNOPSIS
    Create a separate Claude Code profile and sign in to it.

.DESCRIPTION
    Claude Code reads its settings, credentials and history from the folder named
    by the CLAUDE_CONFIG_DIR environment variable. This script creates a profile
    folder (default: $HOME\.claude-secondary) and runs the sign-in flow inside a
    child process that has CLAUDE_CONFIG_DIR set, so your current terminal and
    your default profile are not touched.

    Run it once per profile.

.PARAMETER Name
    Profile name. Letters, digits and hyphens only. The folder becomes
    $HOME\.claude-<Name>. Default: secondary

.EXAMPLE
    .\scripts\Setup-ClaudeProfile.ps1

.EXAMPLE
    .\scripts\Setup-ClaudeProfile.ps1 -Name work
#>
[CmdletBinding()]
param(
    [ValidatePattern('^[A-Za-z0-9-]+$')]
    [string]$Name = 'secondary'
)

$ErrorActionPreference = 'Stop'

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host '[ERROR] "claude" was not found in PATH. Install Claude Code first.' -ForegroundColor Red
    exit 1
}

$ConfigDir = Join-Path $HOME ".claude-$Name"
if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir | Out-Null
    Write-Host "[OK] Created profile folder: $ConfigDir"
} else {
    Write-Host "[INFO] Profile folder already exists: $ConfigDir"
}

# Prefer PowerShell 7 if it is installed, otherwise Windows PowerShell.
$Shell = if (Get-Command pwsh -ErrorAction SilentlyContinue) { 'pwsh' } else { 'powershell' }

# The child process:
#  1. if this script was started from inside a Claude Code session (CLAUDECODE is set),
#     drops the session variables it inherited (CLAUDE*, except CLAUDE_CONFIG_DIR and
#     CLAUDE_CODE_GIT_BASH_PATH) so the new session does not think it is a child session,
#  2. points CLAUDE_CONFIG_DIR at the profile folder,
#  3. signs in and prints the result.
$Child = @"
if (`$env:CLAUDECODE) { Get-ChildItem Env: | Where-Object { `$_.Name -like 'CLAUDE*' -and `$_.Name -notin @('CLAUDE_CONFIG_DIR', 'CLAUDE_CODE_GIT_BASH_PATH') } | ForEach-Object { Remove-Item "Env:`$(`$_.Name)" } }
`$env:CLAUDE_CONFIG_DIR = '$($ConfigDir -replace "'", "''")'
claude auth login
claude auth status
"@
$Encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Child))

Write-Host "[INFO] Signing in to profile '$Name'. A browser window may open."
& $Shell -NoLogo -EncodedCommand $Encoded

Write-Host ''
Write-Host "[OK] Done. Start this profile with:"
Write-Host "     .\scripts\Start-ClaudeProfile.ps1 -Name $Name"
