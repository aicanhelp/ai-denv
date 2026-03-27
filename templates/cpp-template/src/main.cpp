/**
 * @file main.cpp
 * @brief Main entry point for the C++ Template project
 * @author Templ Project
 * @date 2025-09-09
 *
 * Demonstrates modern C++ usage and clean code practices
 */

#include <iostream>
#include <stdexcept>

#include "greeter.hpp"

/**
 * @brief Main function that demonstrates the template functionality
 * @return int Exit code (0 for success, 1 for error)
 */
// NOLINTNEXTLINE(bugprone-exception-escape)
int main() noexcept {
  try {
    const std::string message = cpp_template::Hello("World");
    std::cout << message << '\n';
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Error: " << e.what() << '\n';
    return 1;
  } catch (...) {
    std::cerr << "Error: Unknown exception occurred\n";
    return 1;
  }
}
