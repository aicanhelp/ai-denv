#!/usr/bin/env pwsh
<#
.SYNOPSIS
Runs Pester tests for PowerShell scripts.

.DESCRIPTION
Installs Pester if not available and runs all tests in the test folder.

.PARAMETER Path
Path pattern for test files. Default: 'test/*.Tests.ps1'

.PARAMETER Output
Output verbosity level. Default: 'Detailed'

.EXAMPLE
.scripts/run-pester.ps1
.scripts/run-pester.ps1 -Path 'test/greeter.Tests.ps1' -Output 'Minimal'
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Path = 'test/*.Tests.ps1',

    [Parameter(Position = 1)]
    [ValidateSet('None', 'Normal', 'Detailed', 'Diagnostic')]
    [string]$Output = 'Detailed'
)

$ErrorActionPreference = 'Stop'

# Install Pester if not available
if (-not (Get-Module -ListAvailable -Name Pester)) {
    [Console]::WriteLine('Installing Pester module...')
    Install-Module -Name Pester -Force -SkipPublisherCheck -Scope CurrentUser
}

# Run Pester tests
[Console]::WriteLine('Running Pester tests...')
Invoke-Pester -Path $Path -Output $Output
