#!/usr/bin/env python3
"""Cross-platform code formatter using clang-format.

Formats C++ source files (.cpp, .hpp, .h) in src/, include/, and tests/ directories.
"""

import subprocess
import sys
import time
from pathlib import Path
from typing import List, Tuple

# Add parent directory to path for pylib imports
sys.path.insert(0, str(Path(__file__).parent))

# pylint: disable=wrong-import-position
from pylib import (
    Colors,
    find_cpp_files,
    fix_windows_console,
    print_error_count,
    print_file_changed,
    print_file_error,
    print_file_unchanged,
    print_fixed_count,
    print_needs_fixing,
    print_summary_header,
)

# Fix Windows console for Unicode output
fix_windows_console()


def check_file_needs_formatting(file: Path, style: str) -> bool:
    """Check if a file needs formatting without modifying it."""
    try:
        result = subprocess.run(
            ["clang-format", "--dry-run", "--Werror", f"--style={style}", str(file)],
            capture_output=True,
            text=True,
            check=False,
        )
        return result.returncode != 0
    except FileNotFoundError:
        return False


def format_single_file(file: Path, fix: bool, style: str) -> Tuple[bool, float, str]:
    """Format a single file.

    Returns:
        Tuple of (changed, elapsed_time, error_message)
    """
    start_time = time.time()

    try:
        # First check if file needs formatting
        needs_formatting = check_file_needs_formatting(file, style)

        if fix and needs_formatting:
            # Apply formatting
            result = subprocess.run(
                ["clang-format", "-i", f"--style={style}", str(file)],
                capture_output=True,
                text=True,
                check=False,
            )
            elapsed = time.time() - start_time

            if result.returncode != 0:
                error_msg = result.stderr.strip() if result.stderr else "Unknown error"
                return False, elapsed, error_msg
            return True, elapsed, ""

        elapsed = time.time() - start_time
        return needs_formatting, elapsed, ""

    except FileNotFoundError:
        elapsed = time.time() - start_time
        return False, elapsed, "clang-format not found"


def _print_file_result(
    file: Path, time_str: str, error: str, changed: bool, fix: bool, use_color: bool
) -> None:
    """Print the result for a single file."""
    if error:
        print_file_error(file, time_str, error, use_color)
    elif changed:
        print_file_changed(file, time_str, fix, use_color)
    else:
        suffix = " (unchanged)" if fix else ""
        print_file_unchanged(file, time_str, suffix, use_color)


def _print_summary(
    mode: str,
    total_time: float,
    error_count: int,
    changed_count: int,
    fix: bool,
    use_color: bool,
) -> int:
    """Print summary and return exit code."""
    print_summary_header(mode, int(total_time * 1000), use_color)

    if error_count > 0:
        print_error_count(error_count, use_color)
        return 1

    if not fix and changed_count > 0:
        print_needs_fixing(changed_count, "formatting", use_color)
        return 1

    if fix and changed_count > 0:
        print_fixed_count(changed_count, "Formatted", use_color)

    return 0


def format_files(files: List[Path], fix: bool = False, style: str = "Google") -> int:
    """Format files with clang-format.

    Args:
        files: List of files to format
        fix: If True, modify files in place. If False, check only.
        style: Clang-format style to use

    Returns:
        0 if successful, non-zero if formatting errors found (in check mode)
    """
    if not files:
        print("No files to format")
        return 0

    use_color = Colors.supports_color()
    mode = "Formatting" if fix else "Checking"

    # Header
    if use_color:
        print(f"{Colors.BOLD}{mode} {len(files)} file(s)...{Colors.RESET}")
    else:
        print(f"{mode} {len(files)} file(s)...")

    changed_count = 0
    error_count = 0
    total_time = 0.0

    for file in files:
        changed, elapsed, error = format_single_file(file, fix, style)
        total_time += elapsed
        time_str = f"{int(elapsed * 1000)}ms"

        if error:
            error_count += 1
        elif changed:
            changed_count += 1

        _print_file_result(file, time_str, error, changed, fix, use_color)

    return _print_summary(mode, total_time, error_count, changed_count, fix, use_color)


def main() -> int:
    """Main entry point."""
    fix = False
    staged = False

    if len(sys.argv) > 1:
        if sys.argv[1] in ["fix", "-i", "--fix"]:
            fix = True
        elif sys.argv[1] == "--staged":
            staged = True
            if len(sys.argv) > 2 and sys.argv[2] in ["fix", "-i", "--fix"]:
                fix = True

    # Find and format files
    directories = ["src", "include", "tests"]
    files = find_cpp_files(directories, staged_only=staged)
    return format_files(files, fix=fix)


if __name__ == "__main__":
    sys.exit(main())
