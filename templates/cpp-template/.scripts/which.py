#!/usr/bin/env python3
"""
Cross-platform command availability checker.
Checks if ALL specified commands are available in PATH.
"""

import sys
import shutil


def main():
    """Check if all commands exist."""
    if len(sys.argv) < 2:
        print("Error: No command specified", file=sys.stderr)
        print("Usage: which.py COMMAND [COMMAND2 COMMAND3 ...]", file=sys.stderr)
        return 1

    commands = sys.argv[1:]

    # Check each command - ALL must be found
    missing = []
    for cmd in commands:
        if not shutil.which(cmd):
            missing.append(cmd)

    if missing:
        if len(missing) == 1:
            print(f"Command '{missing[0]}' not found.", file=sys.stderr)
        else:
            print(f"Commands not found: {', '.join(missing)}", file=sys.stderr)
        return 1

    # All commands found
    return 0


if __name__ == "__main__":
    sys.exit(main())
