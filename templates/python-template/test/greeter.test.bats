#!/usr/bin/env bats
# Tests for greeter.sh - happy path scenarios
#
# Run with: bats test/greeter.test.bats

# Setup: source the greeter module before each test
setup() {
  # Get the directory of the test file
  TEST_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
  # Source the greeter module
  source "${TEST_DIR}/../src/greeter.sh"
}

# =============================================================================
# hello() function tests
# =============================================================================

@test "hello returns greeting with simple name" {
  result="$(hello "World")"
  [ "$result" = "Hello, World!" ]
}

@test "hello returns greeting with multi-word name" {
  result="$(hello "John Doe")"
  [ "$result" = "Hello, John Doe!" ]
}

@test "hello trims whitespace from name" {
  result="$(hello "  Alice  ")"
  [ "$result" = "Hello, Alice!" ]
}

# =============================================================================
# goodbye() function tests
# =============================================================================

@test "goodbye returns farewell with simple name" {
  result="$(goodbye "World")"
  [ "$result" = "Goodbye, World!" ]
}

@test "goodbye returns farewell with multi-word name" {
  result="$(goodbye "Jane Doe")"
  [ "$result" = "Goodbye, Jane Doe!" ]
}

@test "goodbye trims whitespace from name" {
  result="$(goodbye "  Bob  ")"
  [ "$result" = "Goodbye, Bob!" ]
}
