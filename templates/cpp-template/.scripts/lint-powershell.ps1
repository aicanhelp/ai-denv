#!/usr/bin/env pwsh
# Lint PowerShell scripts using PSScriptAnalyzer
#
# Usage:
#   lint-powershell.ps1 [-Fix] [-Staged]
#
# Options:
#   -Fix     Apply fixes automatically
#   -Staged  Only lint files staged in git
#
# Exit codes:
#   0 - Success (no issues or all fixed)
#   1 - Issues found (in check mode)
#   2 - PSScriptAnalyzer not installed

[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Fix')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Staged')]
param(
  [switch]$Fix,
  [switch]$Staged,
  [switch]$Help
)

$ErrorActionPreference = 'Stop'

# ============================================================================
# Configuration
# ============================================================================

# Colors
class Colors {
  static [string] $Reset = "`e[0m"
  static [string] $Red = "`e[31m"
  static [string] $Green = "`e[32m"
  static [string] $Yellow = "`e[33m"
  static [string] $Gray = "`e[90m"
  static [string] $White = "`e[37m"
  static [string] $Cyan = "`e[36m"
}

# Folders to exclude from linting
$IGNORED_FOLDERS = @(
  '.cache',
  '.git',
  '.husky',
  '.task',
  '.venv',
  'bazel-bin',
  'bazel-cpp',
  'bazel-out',
  'bazel-testlogs',
  'build',
  'dist',
  'external',
  'node_modules',
  'target',
  'vendor',
  'venv'
)

# ============================================================================

# Show help
if ($Help) {
  Write-Information "Usage: lint-powershell.ps1 [-Fix] [-Staged]" -InformationAction Continue
  Write-Information "" -InformationAction Continue
  Write-Information "Options:" -InformationAction Continue
  Write-Information "  -Fix     Apply fixes automatically" -InformationAction Continue
  Write-Information "  -Staged  Only lint staged git files" -InformationAction Continue
  Write-Information "  -Help    Show this help message" -InformationAction Continue
  exit 0
}

# Check if PSScriptAnalyzer is installed
function Test-PSScriptAnalyzerInstalled {
  $module = Get-Module -ListAvailable -Name PSScriptAnalyzer
  return $null -ne $module
}

# Install PSScriptAnalyzer if missing
function Install-PSScriptAnalyzerModule {
  Write-Information "$([Colors]::Yellow)Installing PSScriptAnalyzer...$([Colors]::Reset)" -InformationAction Continue
  try {
    Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser -SkipPublisherCheck -ErrorAction Stop
    Write-Information "$([Colors]::Green)✓ PSScriptAnalyzer installed successfully$([Colors]::Reset)" -InformationAction Continue
  }
  catch {
    Write-Error "$([Colors]::Red)✗ Failed to install PSScriptAnalyzer: $_$([Colors]::Reset)"
    exit 2
  }
}

# Get list of PowerShell scripts
function Get-PowerShellScript {
  # Use current working directory as the repository root
  # The task system ensures we're running from the repo root
  $repoRoot = Get-Location | Select-Object -ExpandProperty Path

  if ($Staged) {
    # Get only staged .ps1 files
    $stagedFiles = git diff --cached --name-only --diff-filter=ACM | Where-Object { $_ -match '\.ps1$' }
    return $stagedFiles | ForEach-Object {
      $filePath = Join-Path $repoRoot $_
      if (Test-Path $filePath) {
        Get-Item $filePath
      }
    }
  }
  else {
    # Get all .ps1 files excluding ignored directories
    # Use a custom recursive function for better performance - it skips excluded dirs entirely
    $results = [System.Collections.ArrayList]::new()

    function Get-PowerShellScriptsRecursive {
      param([string]$path, [System.Collections.ArrayList]$resultList)

      try {
        # Get all items in current directory (non-recursive)
        $items = Get-ChildItem -Path $path -Force -ErrorAction SilentlyContinue

        foreach ($item in $items) {
          # Skip if folder name is in ignored list
          if ($item.PSIsContainer -and $IGNORED_FOLDERS -contains $item.Name) {
            continue
          }

          # If it's a .ps1 file, add it
          if (-not $item.PSIsContainer -and $item.Extension -eq '.ps1') {
            [void]$resultList.Add($item)
          }

          # If it's a directory (and not ignored), recurse into it
          if ($item.PSIsContainer) {
            Get-PowerShellScriptsRecursive -path $item.FullName -resultList $resultList
          }
        }
      }
      catch {
        # Silently skip directories we can't access (permission denied, etc.)
        Write-Verbose "Skipping inaccessible path: $path - $_"
      }
    }

    Get-PowerShellScriptsRecursive -path $repoRoot -resultList $results
    return $results.ToArray()
  }
}

# Main linting logic
function Invoke-LintPowerShell {
  # Ensure PSScriptAnalyzer is available
  if (-not (Test-PSScriptAnalyzerInstalled)) {
    Install-PSScriptAnalyzerModule
  }

  # Get settings file path
  $settingsFile = Join-Path -Path $PSScriptRoot -ChildPath ".." | Join-Path -ChildPath ".PSScriptAnalyzerSettings.psd1"
  if (-not (Test-Path -Path $settingsFile)) {
    $settingsFile = $null
  }

  # Get list of PowerShell scripts
  $scripts = Get-PowerShellScript

  if (-not $scripts -or $scripts.Count -eq 0) {
    Write-Information "$([Colors]::Yellow)No PowerShell scripts found to lint$([Colors]::Reset)" -InformationAction Continue
    exit 0
  }

  Write-Information "PSScriptAnalyzer: Linting PowerShell scripts..." -InformationAction Continue
  Write-Information "" -InformationAction Continue

  $hasIssues = $false
  $fileCount = 0

  foreach ($script in $scripts) {
    $fileCount++

    if ($Fix) {
      # Apply fixes
      $params = @{
        Path = $script.FullName
        Fix = $true
      }
      if ($settingsFile) {
        $params['Settings'] = $settingsFile
      }

      try {
        $fixes = Invoke-ScriptAnalyzer @params -ErrorAction SilentlyContinue

        if ($fixes) {
          Write-Information "$([Colors]::White)  Fixed: $($script.Name)$([Colors]::Reset)" -InformationAction Continue
        }
      }
      catch {
        Write-Warning "$([Colors]::Yellow)  Warning: Could not apply fixes to $($script.Name)$([Colors]::Reset)"
      }

      # Check for remaining issues
      $params.Remove('Fix')
      $issues = Invoke-ScriptAnalyzer @params -ErrorAction SilentlyContinue

      if ($issues) {
        $hasIssues = $true
        Write-Information "$([Colors]::White)$($script.Name)$([Colors]::Reset)" -InformationAction Continue
        $issues | Format-Table -Property Line, Severity, RuleName, Message -AutoSize | Out-String | Write-Information -InformationAction Continue
      }
      else {
        Write-Information "$([Colors]::Gray)  OK: $($script.Name)$([Colors]::Reset)" -InformationAction Continue
      }
    }
    else {
      # Check-only mode
      $params = @{
        Path = $script.FullName
      }
      if ($settingsFile) {
        $params['Settings'] = $settingsFile
      }

      $issues = Invoke-ScriptAnalyzer @params -ErrorAction SilentlyContinue

      if ($issues) {
        $hasIssues = $true
        Write-Information "$([Colors]::White)$($script.Name)$([Colors]::Reset)" -InformationAction Continue
        $issues | Format-Table -Property Line, Severity, RuleName, Message -AutoSize | Out-String | Write-Information -InformationAction Continue
        Write-Information "" -InformationAction Continue
      }
      else {
        Write-Information "$([Colors]::Gray)  OK: $($script.Name)$([Colors]::Reset)" -InformationAction Continue
      }
    }
  }

  Write-Information "" -InformationAction Continue
  Write-Information "Checked $fileCount PowerShell script(s)" -InformationAction Continue

  if ($hasIssues) {
    if ($Fix) {
      Write-Information "" -InformationAction Continue
      Write-Warning "$([Colors]::Yellow)⚠ Some issues could not be auto-fixed$([Colors]::Reset)"
      Write-Information "Please review and fix them manually" -InformationAction Continue
      exit 1
    }
    else {
      Write-Error "$([Colors]::Red)✗ PSScriptAnalyzer found issues$([Colors]::Reset)"
      Write-Information "Run with -Fix to apply automatic fixes: .\lint-powershell.ps1 -Fix" -InformationAction Continue
      exit 1
    }
  }
  else {
    Write-Information "$([Colors]::Green)✓ All PowerShell scripts are clean$([Colors]::Reset)" -InformationAction Continue
    exit 0
  }
}

# Run main function
Invoke-LintPowerShell
