#!/usr/bin/env bash
# Lint shell scripts using ShellCheck
#
# Usage:
#   lint-shellcheck.sh [--fix] [--staged]
#
# Options:
#   --fix     Apply fixes automatically (using git apply)
#   --staged  Only lint files staged in git
#
# Exit codes:
#   0 - Success (no issues or all fixed)
#   1 - Issues found (in check mode)
#   2 - ShellCheck not installed

set -euo pipefail

# Colors
readonly COLOR_RESET='\033[0m'
readonly COLOR_RED='\033[31m'
readonly COLOR_GREEN='\033[32m'
readonly COLOR_YELLOW='\033[33m'
readonly COLOR_GRAY='\033[90m'
readonly COLOR_WHITE='\033[37m'

# Default options
FIX_MODE=false
STAGED_MODE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --fix)
      FIX_MODE=true
      shift
      ;;
    --staged)
      STAGED_MODE=true
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [--fix] [--staged]"
      echo ""
      echo "Options:"
      echo "  --fix     Apply fixes automatically"
      echo "  --staged  Only lint staged git files"
      echo "  --help    Show this help message"
      exit 0
      ;;
    *)
      echo -e "${COLOR_RED}Unknown option: $1${COLOR_RESET}" >&2
      exit 1
      ;;
  esac
done

# Check if shellcheck is installed
if ! command -v shellcheck >/dev/null 2>&1; then
  echo -e "${COLOR_RED}✗ ShellCheck is not installed${COLOR_RESET}" >&2
  echo "Install it: https://github.com/koalaman/shellcheck#installing" >&2
  exit 2
fi

# Get list of shell scripts
get_shell_scripts() {
  if [[ "$STAGED_MODE" == "true" ]]; then
    # Only get staged .sh files
    git diff --cached --name-only --diff-filter=ACM | grep '\.sh$' || true
  else
    # Find all .sh files excluding common directories
    find . -type f -iname "*.sh" \
      -not -path "./.cache/*" \
      -not -path "./.git/*" \
      -not -path "./.husky/*" \
      -not -path "./.task/*" \
      -not -path "./.venv/*" \
      -not -path "./bazel*/*" \
      -not -path "./build/*" \
      -not -path "./dist/*" \
      -not -path "./external/*" \
      -not -path "./node_modules/*" \
      -not -path "./target/*" \
      -not -path "./vendor/*" \
      -not -path "./vendors/*" \
      -not -path "./venv/*"
  fi
}

# Main linting logic
main() {
  local files
  files=$(get_shell_scripts)

  if [[ -z "$files" ]]; then
    echo -e "${COLOR_YELLOW}No shell scripts found to lint${COLOR_RESET}"
    exit 0
  fi

  local has_issues=false
  local file_count=0

  echo "ShellCheck: Linting shell scripts..."
  echo ""

  while IFS= read -r file; do
    [[ -z "$file" ]] && continue

    file_count=$((file_count + 1))

    if [[ "$FIX_MODE" == "true" ]]; then
      # Apply fixes using shellcheck diff output
      local diff_output
      diff_output=$(shellcheck -x --severity=style --format=diff "$file" 2>&1) || true

      if [[ -n "$diff_output" ]]; then
        echo "$diff_output" | git apply --allow-empty 2>&1 || true
        echo -e "${COLOR_WHITE}  Fixed: ${file#./}${COLOR_RESET}"
      fi

      # Check for remaining issues
      local tty_output
      tty_output=$(shellcheck -x --severity=style --format=tty "$file" 2>&1) || true

      if [[ -n "$tty_output" ]]; then
        has_issues=true
        echo -e "${COLOR_WHITE}${file#./}${COLOR_RESET}"
        echo "$tty_output"
      else
        echo -e "${COLOR_GRAY}  OK: ${file#./}${COLOR_RESET}"
      fi
    else
      # Check-only mode
      local tty_output
      tty_output=$(shellcheck -x --severity=style --format=tty "$file" 2>&1) || true

      if [[ -n "$tty_output" ]]; then
        has_issues=true
        echo -e "${COLOR_WHITE}${file#./}${COLOR_RESET}"
        echo "$tty_output"
        echo ""
      else
        echo -e "${COLOR_GRAY}  OK: ${file#./}${COLOR_RESET}"
      fi
    fi
  done <<< "$files"

  echo ""
  echo "Checked $file_count shell script(s)"

  if [[ "$has_issues" == "true" ]]; then
    if [[ "$FIX_MODE" == "true" ]]; then
      echo -e "${COLOR_YELLOW}⚠ Some issues could not be auto-fixed${COLOR_RESET}"
      echo "Please review and fix them manually"
      exit 1
    else
      echo -e "${COLOR_RED}✗ ShellCheck found issues${COLOR_RESET}"
      echo "Run with --fix to apply automatic fixes: $0 --fix"
      exit 1
    fi
  else
    echo -e "${COLOR_GREEN}✓ All shell scripts are clean${COLOR_RESET}"
    exit 0
  fi
}

main
