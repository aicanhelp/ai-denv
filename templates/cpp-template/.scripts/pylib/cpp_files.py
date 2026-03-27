"""C++ source file discovery utilities.

This module provides functions to find C++ source files for formatting
and linting operations.
"""

import subprocess
import sys
from pathlib import Path
from typing import List


def find_cpp_files(directories: List[str], staged_only: bool = False) -> List[Path]:
    """Find all C++ source files in the specified directories.

    Args:
        directories: List of directory names to search (e.g., ["src", "include"]).
        staged_only: If True, only return staged files from git.

    Returns:
        Sorted list of Path objects for matching files.
    """
    files: List[Path] = []

    if staged_only:
        files = _get_staged_cpp_files()
    else:
        for directory in directories:
            dir_path = Path(directory)
            if dir_path.exists():
                for ext in ["*.cpp", "*.hpp", "*.h"]:
                    files.extend(dir_path.rglob(ext))

    return sorted(files)


def _get_staged_cpp_files() -> List[Path]:
    """Get staged C++ files from git.

    Returns:
        List of Path objects for staged C++ files.
    """
    files: List[Path] = []
    try:
        result = subprocess.run(
            ["git", "status", "--porcelain", "--cached"],
            capture_output=True,
            text=True,
            check=True,
        )
        for line in result.stdout.splitlines():
            if line and any(line.endswith(ext) for ext in [".cpp", ".hpp", ".h"]):
                filepath = Path(line[3:].strip())
                if filepath.exists():
                    files.append(filepath)
    except subprocess.CalledProcessError:
        print("Warning: Could not get staged files from git", file=sys.stderr)
    return files
