#!/usr/bin/env pwsh
# Lint shell scripts using ShellCheck
#
# Usage:
#   lint-shellcheck.ps1 [-Fix] [-Staged]
#
# Options:
#   -Fix     Apply fixes automatically (using git apply)
#   -Staged  Only lint files staged in git
#
# Exit codes:
#   0 - Success (no issues or all fixed)
#   1 - Issues found (in check mode)
#   2 - ShellCheck not installed

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

# Show help if requested
if ($Help) {
  Write-Information 'Usage: lint-shellcheck.ps1 [-Fix] [-Staged]' -InformationAction Continue
  Write-Information '' -InformationAction Continue
  Write-Information 'Options:' -InformationAction Continue
  Write-Information '  -Fix     Apply fixes automatically' -InformationAction Continue
  Write-Information '  -Staged  Only lint staged git files' -InformationAction Continue
  Write-Information '  -Help    Show this help message' -InformationAction Continue
  exit 0
}

# Check if shellcheck is installed
if (-not (Get-Command shellcheck -ErrorAction SilentlyContinue)) {
  Write-Error "$([Colors]::Red)✗ ShellCheck is not installed$([Colors]::Reset)"
  Write-Information 'Install it: https://github.com/koalaman/shellcheck#installing' -InformationAction Continue
  exit 2
}

# Get list of shell scripts
function Get-ShellScript {
  $repoRoot = Get-Location | Select-Object -ExpandProperty Path

  if ($Staged) {
    # Only get staged .sh files
    $stagedFiles = git diff --cached --name-only --diff-filter=ACM | Where-Object { $_ -match '\.sh$' }
    return $stagedFiles | ForEach-Object {
      Join-Path $repoRoot $_
    }
  }
  else {
    # Find all .sh files excluding common directories
    Get-ChildItem -Path $repoRoot -Filter '*.sh' -Recurse -File | Where-Object {
      $path = $_.FullName
      $excluded = $false
      foreach ($dir in $IGNORED_FOLDERS) {
        if ($path -like "*\$dir\*") {
          $excluded = $true
          break
        }
      }
      -not $excluded
    } | Select-Object -ExpandProperty FullName
  }
}

# Main linting logic
function Invoke-Linting {
  $files = @(Get-ShellScript)

  if ($files.Count -eq 0) {
    Write-Information "$([Colors]::Yellow)No shell scripts found to lint$([Colors]::Reset)" -InformationAction Continue
    exit 0
  }

  $hasIssues = $false
  $fileCount = 0

  Write-Information 'ShellCheck: Linting shell scripts...' -InformationAction Continue
  Write-Information '' -InformationAction Continue

  foreach ($file in $files) {
    if (-not $file) { continue }

    $fileCount++
    $currentPath = Get-Location | Select-Object -ExpandProperty Path
    $relativePath = if ($file.StartsWith($currentPath)) {
      $file.Substring($currentPath.Length).TrimStart('\', '/')
    }
    else {
      $file
    }

    if ($Fix) {
      # Apply fixes using shellcheck diff output
      $diffOutput = shellcheck -x --severity=style --format=diff $file 2>&1

      if ($LASTEXITCODE -ne 0 -and $diffOutput) {
        $diffOutput | git apply --allow-empty 2>&1 | Out-Null
        Write-Information "$([Colors]::White)  Fixed: $relativePath$([Colors]::Reset)" -InformationAction Continue
      }

      # Check for remaining issues
      $ttyOutput = shellcheck -x --severity=style --format=tty $file 2>&1

      if ($LASTEXITCODE -ne 0 -and $ttyOutput) {
        $hasIssues = $true
        Write-Information "$([Colors]::White)$relativePath$([Colors]::Reset)" -InformationAction Continue
        Write-Information $ttyOutput -InformationAction Continue
      }
      else {
        Write-Information "$([Colors]::Gray)  OK: $relativePath$([Colors]::Reset)" -InformationAction Continue
      }
    }
    else {
      # Check-only mode
      $ttyOutput = shellcheck -x --severity=style --format=tty $file 2>&1

      if ($LASTEXITCODE -ne 0 -and $ttyOutput) {
        $hasIssues = $true
        Write-Information "$([Colors]::White)$relativePath$([Colors]::Reset)" -InformationAction Continue
        Write-Information $ttyOutput -InformationAction Continue
        Write-Information '' -InformationAction Continue
      }
      else {
        Write-Information "$([Colors]::Gray)  OK: $relativePath$([Colors]::Reset)" -InformationAction Continue
      }
    }
  }

  Write-Information '' -InformationAction Continue
  Write-Information "Checked $fileCount shell script(s)" -InformationAction Continue

  if ($hasIssues) {
    if ($Fix) {
      Write-Information "" -InformationAction Continue
      Write-Warning "$([Colors]::Yellow)⚠ Some issues could not be auto-fixed$([Colors]::Reset)"
      Write-Information 'Please review and fix them manually' -InformationAction Continue
      exit 1
    }
    else {
      Write-Error "$([Colors]::Red)✗ ShellCheck found issues$([Colors]::Reset)"
      Write-Information 'Run with -Fix to apply automatic fixes: .\lint-shellcheck.ps1 -Fix' -InformationAction Continue
      exit 1
    }
  }
  else {
    Write-Information "$([Colors]::Green)✓ All shell scripts are clean$([Colors]::Reset)" -InformationAction Continue
    exit 0
  }
}

Invoke-Linting
