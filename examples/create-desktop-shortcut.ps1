<#
.SYNOPSIS
    Create a desktop shortcut that opens Claude Code with a given profile.

.EXAMPLE
    .\examples\create-desktop-shortcut.ps1 -Name secondary -ProjectPath D:\code\api
#>
[CmdletBinding()]
param(
    [ValidatePattern('^[A-Za-z0-9-]+$')]
    [string]$Name = 'secondary',
    [Parameter(Mandatory)]
    [string]$ProjectPath
)

$ErrorActionPreference = 'Stop'

$Starter = Join-Path $PSScriptRoot '..\scripts\Start-ClaudeProfile.ps1' | Resolve-Path
$Project = (Resolve-Path $ProjectPath).Path
$Desktop = [Environment]::GetFolderPath('Desktop')
$LinkPath = Join-Path $Desktop "Claude ($Name).lnk"

$Shell = New-Object -ComObject WScript.Shell
$Link = $Shell.CreateShortcut($LinkPath)
$Link.TargetPath = 'powershell.exe'
$Link.Arguments = "-NoLogo -ExecutionPolicy Bypass -File `"$Starter`" -Name $Name -ProjectPath `"$Project`" -SameWindow"
$Link.WorkingDirectory = $Project
$Link.Save()

Write-Host "[OK] Shortcut created: $LinkPath"
