#!/usr/bin/env python3
"""Cross-platform code linter using clang-tidy.

Lints C++ source files (.cpp, .hpp, .h) in src/ and include/ directories.
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


def lint_single_file(
    file: Path, fix: bool, build_dir: str = "build"
) -> Tuple[bool, float, str]:
    """Lint a single file with clang-tidy.

    Returns:
        Tuple of (has_issues, elapsed_time, output_message)
    """
    start_time = time.time()

    try:
        args = ["clang-tidy", "-p", build_dir, "--config-file=.clang-tidy", "--quiet"]

        # Suppress MSVC compatibility warnings on Windows
        if sys.platform == "win32":
            args.extend(
                [
                    "--checks=-clang-diagnostic-builtin-macro-redefined,"
                    "-clang-diagnostic-unused-command-line-argument"
                ]
            )

        if fix:
            args.append("--fix")

        args.append(str(file))

        result = subprocess.run(args, capture_output=True, text=True, check=False)

        elapsed = time.time() - start_time
        has_issues = result.returncode != 0 or bool(result.stdout.strip())

        if result.returncode != 0 and result.stderr:
            return has_issues, elapsed, result.stderr.strip()

        output = result.stdout.strip() if result.stdout.strip() else ""
        return has_issues, elapsed, output

    except FileNotFoundError:
        elapsed = time.time() - start_time
        return False, elapsed, "clang-tidy not found"


def _print_file_result(
    file: Path,
    time_str: str,
    output: str,
    has_issues: bool,
    fix: bool,
    use_color: bool,
) -> None:
    """Print the result for a single file."""
    if output and "error:" in output.lower():
        print_file_error(file, time_str, output, use_color)
    elif has_issues:
        print_file_changed(file, time_str, fix, use_color)
        if output and not fix:
            if use_color:
                print(f"{Colors.DIM}{output}{Colors.RESET}")
            else:
                print(output)
    else:
        suffix = " (clean)" if fix else ""
        print_file_unchanged(file, time_str, suffix, use_color)


def _print_summary(
    mode: str,
    total_time: float,
    error_count: int,
    issues_count: int,
    fix: bool,
    use_color: bool,
) -> int:
    """Print summary and return exit code."""
    print_summary_header(mode, int(total_time * 1000), use_color)

    if error_count > 0:
        print_error_count(error_count, use_color)
        return 1

    if not fix and issues_count > 0:
        print_needs_fixing(issues_count, "linting issues", use_color)
        return 1

    if fix and issues_count > 0:
        print_fixed_count(issues_count, "Fixed issues in", use_color)

    return 0


def lint_files(files: List[Path], fix: bool = False, build_dir: str = "build") -> int:
    """Lint files with clang-tidy.

    Args:
        files: List of files to lint
        fix: If True, apply fixes. If False, check only.
        build_dir: Build directory containing compile_commands.json

    Returns:
        0 if successful, non-zero if linting issues found
    """
    if not files:
        print("No files to lint")
        return 0

    # Check if compile_commands.json exists
    compile_db = Path(build_dir) / "compile_commands.json"
    if not compile_db.exists():
        # Also check root directory (some generators put it there)
        root_compile_db = Path("compile_commands.json")
        if not root_compile_db.exists():
            print(
                f"⚠ Skipping clang-tidy: no compile_commands.json found in {build_dir}/ or project root"
            )
            print(
                "  This is expected for Bazel builds on macOS (Hedron has SDK header issues)"
            )
            return 0

    use_color = Colors.supports_color()
    mode = "Linting and fixing" if fix else "Linting"

    # Header
    if use_color:
        print(f"{Colors.BOLD}{mode} {len(files)} file(s)...{Colors.RESET}")
    else:
        print(f"{mode} {len(files)} file(s)...")

    issues_count = 0
    error_count = 0
    total_time = 0.0

    for file in files:
        has_issues, elapsed, output = lint_single_file(file, fix, build_dir)
        total_time += elapsed
        time_str = f"{int(elapsed * 1000)}ms"

        if output and "error:" in output.lower():
            error_count += 1
        elif has_issues:
            issues_count += 1

        _print_file_result(file, time_str, output, has_issues, fix, use_color)

    return _print_summary(mode, total_time, error_count, issues_count, fix, use_color)


def main() -> int:
    """Main entry point."""
    fix = False
    staged = False
    build_dir = "build"

    i = 1
    while i < len(sys.argv):
        arg = sys.argv[i]
        if arg in ["fix", "--fix"]:
            fix = True
        elif arg == "--staged":
            staged = True
        elif arg in ["-p", "--build-dir"]:
            if i + 1 < len(sys.argv):
                build_dir = sys.argv[i + 1]
                i += 1
        i += 1

    # Find and lint files (excluding tests for clang-tidy)
    directories = ["src", "include"]
    files = find_cpp_files(directories, staged_only=staged)
    return lint_files(files, fix=fix, build_dir=build_dir)


if __name__ == "__main__":
    sys.exit(main())
