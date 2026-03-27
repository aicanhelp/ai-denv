#Requires -Modules Pester
<#
.SYNOPSIS
Tests for greeter.ps1 - happy path scenarios

.DESCRIPTION
Run with: Invoke-Pester -Path test/greeter.Tests.ps1
#>

BeforeAll {
  # Get the directory of the test file and source the greeter module
  $TestDir = Split-Path -Path $PSCommandPath -Parent
  . "$TestDir/../src/greeter.ps1"
}

Describe "Hello function" {
  Context "Happy path scenarios" {
    It "Returns greeting with simple name" {
      $result = Hello -Name "World"
      $result | Should -Be "Hello, World!"
    }

    It "Returns greeting with multi-word name" {
      $result = Hello -Name "John Doe"
      $result | Should -Be "Hello, John Doe!"
    }

    It "Trims whitespace from name" {
      $result = Hello -Name "  Alice  "
      $result | Should -Be "Hello, Alice!"
    }

    It "Accepts positional parameter" {
      $result = Hello "Bob"
      $result | Should -Be "Hello, Bob!"
    }
  }
}

Describe "Goodbye function" {
  Context "Happy path scenarios" {
    It "Returns farewell with simple name" {
      $result = Goodbye -Name "World"
      $result | Should -Be "Goodbye, World!"
    }

    It "Returns farewell with multi-word name" {
      $result = Goodbye -Name "Jane Doe"
      $result | Should -Be "Goodbye, Jane Doe!"
    }

    It "Trims whitespace from name" {
      $result = Goodbye -Name "  Charlie  "
      $result | Should -Be "Goodbye, Charlie!"
    }

    It "Accepts positional parameter" {
      $result = Goodbye "Dave"
      $result | Should -Be "Goodbye, Dave!"
    }
  }
}
