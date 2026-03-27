"""Shared Python utilities for linting scripts.

This package provides common abstractions and utilities for building
consistent file linters.
"""

from .cpp_files import find_cpp_files
from .file_finder import find_files
from .linter import Colors, Linter, fix_windows_console
from .output import (
    print_error_count,
    print_file_changed,
    print_file_error,
    print_file_unchanged,
    print_fixed_count,
    print_needs_fixing,
    print_summary_header,
)

__all__ = [
    "Colors",
    "Linter",
    "find_cpp_files",
    "find_files",
    "fix_windows_console",
    "print_error_count",
    "print_file_changed",
    "print_file_error",
    "print_file_unchanged",
    "print_fixed_count",
    "print_needs_fixing",
    "print_summary_header",
]
