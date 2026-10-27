<#
.SYNOPSIS
    Open Claude Code with a separate profile, in a new window or the current one.

.DESCRIPTION
    Starts Claude Code with CLAUDE_CONFIG_DIR pointing at $HOME\.claude-<Name>.
    The variable is set only inside the new process, so other terminals keep
    using your default profile.

.PARAMETER Name
    Profile name created with Setup-ClaudeProfile.ps1. Default: secondary

.PARAMETER ProjectPath
    Folder to open Claude Code in. Default: the current folder.

.PARAMETER SameWindow
    Run in the current terminal instead of opening a new window.
    The current terminal's own environment is left unchanged.

.PARAMETER DryRun
    Print what would be run, without starting anything.

.EXAMPLE
    .\scripts\Start-ClaudeProfile.ps1

.EXAMPLE
    .\scripts\Start-ClaudeProfile.ps1 -Name work -ProjectPath D:\code\api
#>
[CmdletBinding()]
param(
    [ValidatePattern('^[A-Za-z0-9-]+$')]
    [string]$Name = 'secondary',
    [string]$ProjectPath = (Get-Location).Path,
    [switch]$SameWindow,
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$ConfigDir = Join-Path $HOME ".claude-$Name"
if (-not (Test-Path $ConfigDir)) {
    Write-Host "[ERROR] Profile folder not found: $ConfigDir" -ForegroundColor Red
    Write-Host "        Run .\scripts\Setup-ClaudeProfile.ps1 -Name $Name first."
    exit 1
}
if (-not (Test-Path $ProjectPath -PathType Container)) {
    Write-Host "[ERROR] Project folder not found: $ProjectPath" -ForegroundColor Red
    exit 1
}
$ProjectPath = (Resolve-Path $ProjectPath).Path

$Shell = if (Get-Command pwsh -ErrorAction SilentlyContinue) { 'pwsh' } else { 'powershell' }

# Escape single quotes for use inside a single-quoted PowerShell string.
$Dir  = $ConfigDir   -replace "'", "''"
$Proj = $ProjectPath -replace "'", "''"

$Child = @"
if (`$env:CLAUDECODE) { Get-ChildItem Env: | Where-Object { `$_.Name -like 'CLAUDE*' -and `$_.Name -notin @('CLAUDE_CONFIG_DIR', 'CLAUDE_CODE_GIT_BASH_PATH') } | ForEach-Object { Remove-Item "Env:`$(`$_.Name)" } }
`$env:CLAUDE_CONFIG_DIR = '$Dir'
`$Host.UI.RawUI.WindowTitle = 'Claude Code [$Name]'
Set-Location -LiteralPath '$Proj'
claude
"@

if ($DryRun) {
    Write-Host "[DRY-RUN] shell: $Shell"
    Write-Host "[DRY-RUN] new window: $(-not $SameWindow)"
    Write-Host $Child
    exit 0
}

$Encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Child))

if ($SameWindow) {
    & $Shell -NoLogo -EncodedCommand $Encoded
} else {
    Start-Process $Shell -ArgumentList '-NoExit', '-NoLogo', '-EncodedCommand', $Encoded
    Write-Host "[OK] Opened a new window for profile '$Name' in $ProjectPath"
}
