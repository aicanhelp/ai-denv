"""Output formatting utilities for CLI tools.

This module provides common output formatting functions for file processing
tools with consistent colored terminal output.
"""

import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

from .linter import Colors


@dataclass
class FileResult:
    """Result from processing a single file."""

    path: Path
    elapsed_ms: int
    error: Optional[str] = None
    changed: bool = False
    has_issues: bool = False
    output: Optional[str] = None


def print_file_error(file: Path, time_str: str, error: str, use_color: bool) -> None:
    """Print error result for a file."""
    if use_color:
        print(
            f"{Colors.RED}✖{Colors.RESET} {file} {Colors.WHITE}{time_str}{Colors.RESET}"
        )
        print(f"  {Colors.RED}Error: {error}{Colors.RESET}", file=sys.stderr)
    else:
        print(f"✖ {file} {time_str}")
        print(f"  Error: {error}", file=sys.stderr)


def print_file_changed(file: Path, time_str: str, fix: bool, use_color: bool) -> None:
    """Print result for a file that was changed or needs changes."""
    if use_color:
        symbol = "✓" if fix else "⚠"
        color = Colors.GREEN if fix else Colors.YELLOW
        print(
            f"{color}{symbol}{Colors.RESET} {Colors.WHITE}{file}{Colors.RESET} "
            f"{Colors.WHITE}{time_str}{Colors.RESET}"
        )
    else:
        symbol = "✓" if fix else "!"
        print(f"{symbol} {file} {time_str}")


def print_file_unchanged(
    file: Path, time_str: str, suffix: str, use_color: bool
) -> None:
    """Print result for an unchanged/clean file."""
    if use_color:
        print(
            f"{Colors.GRAY}  {file}{Colors.RESET} "
            f"{Colors.WHITE}{time_str}{suffix}{Colors.RESET}"
        )
    else:
        print(f"  {file} {time_str}{suffix}")


def print_summary_header(mode: str, total_time_ms: int, use_color: bool) -> None:
    """Print summary header with timing."""
    print()
    if use_color:
        print(f"{Colors.BOLD}{mode} completed in {total_time_ms}ms!{Colors.RESET}")
    else:
        print(f"{mode} completed in {total_time_ms}ms!")


def print_error_count(error_count: int, use_color: bool) -> None:
    """Print error count message."""
    if use_color:
        print(
            f"{Colors.RED}✖ {error_count} file(s) had errors{Colors.RESET}",
            file=sys.stderr,
        )
    else:
        print(f"✖ {error_count} file(s) had errors", file=sys.stderr)


def print_needs_fixing(count: int, fix_hint: str, use_color: bool) -> None:
    """Print message about files that need fixing."""
    if use_color:
        print(f"{Colors.YELLOW}⚠ {count} file(s) need {fix_hint}{Colors.RESET}")
        print(f"{Colors.DIM}Use '--fix' to fix them.{Colors.RESET}")
    else:
        print(f"! {count} file(s) need {fix_hint}")
        print("Use '--fix' to fix them.")


def print_fixed_count(count: int, action: str, use_color: bool) -> None:
    """Print message about fixed files."""
    if use_color:
        print(f"{Colors.GREEN}✓ {action} {count} file(s){Colors.RESET}")
    else:
        print(f"✓ {action} {count} file(s)")
