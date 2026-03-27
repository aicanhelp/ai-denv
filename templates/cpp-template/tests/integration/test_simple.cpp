/**
 * @file test_simple.cpp
 * @brief Simple test without external dependencies
 * @author Templ Project
 * @date 2025-09-09
 */

#include <cassert>
#include <iostream>
#include <stdexcept>

#include "greeter.hpp"

void test_hello_basic() {
  const std::string result = cpp_template::Hello("World");
  (void)result;  // Explicitly mark as used for clang-tidy
  assert(result == "Hello, World!");
  std::cout << "✓ Hello basic test passed" << '\n';
}

void test_hello_with_whitespace() {
  const std::string result = cpp_template::Hello("  C++  ");
  (void)result;  // Explicitly mark as used for clang-tidy
  assert(result == "Hello, C++!");
  std::cout << "✓ Hello whitespace test passed" << '\n';
}

void test_hello_empty_throws() {
  try {
    cpp_template::Hello("");
    assert(false && "Should have thrown exception");
  } catch (const cpp_template::InvalidNameError&) {
    std::cout << "✓ Hello empty string test passed" << '\n';
  }
}

void test_goodbye_basic() {
  const std::string result = cpp_template::Goodbye("World");
  (void)result;  // Explicitly mark as used for clang-tidy
  assert(result == "Goodbye, World!");
  std::cout << "✓ Goodbye basic test passed" << '\n';
}

void test_trim_function() {
  assert(cpp_template::Trim("  hello  ") == "hello");
  assert(cpp_template::Trim("").empty());
  std::cout << "✓ Trim function test passed" << '\n';
}

int main() {
  std::cout << "Running simple C++ template tests..." << '\n';

  try {
    test_hello_basic();
    test_hello_with_whitespace();
    test_hello_empty_throws();
    test_goodbye_basic();
    test_trim_function();

    std::cout << "\n✅ All tests passed!" << '\n';
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "\n❌ Test failed: " << e.what() << '\n';
    return 1;
  }
}
