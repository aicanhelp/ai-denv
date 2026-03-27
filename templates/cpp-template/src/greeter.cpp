/**
 * @file greeter.cpp
 * @brief Implementation of the greeter module
 * @author Templ Project
 * @date 2025-09-09
 */

#include "greeter.hpp"

#include <algorithm>
#include <cctype>

namespace cpp_template {

std::string_view Trim(std::string_view str) {
  // Find first non-whitespace character
  const auto start_pos = str.find_first_not_of(" \t\n\r\f\v");
  if (start_pos == std::string_view::npos) {
    return {};
  }

  // Find last non-whitespace character
  const auto end_pos = str.find_last_not_of(" \t\n\r\f\v");

  // Return substring from start to end
  return str.substr(start_pos, end_pos - start_pos + 1);
}

// Greeter class implementation
std::string Greeter::Hello(const std::string& name) {
  const std::string trimmed_name{Trim(name)};

  if (trimmed_name.empty()) {
    throw InvalidNameError("Name must be a non-empty string");
  }

  return "Hello, " + trimmed_name + "!";
}

std::string Greeter::Goodbye(const std::string& name) {
  const std::string trimmed_name{Trim(name)};

  if (trimmed_name.empty()) {
    throw InvalidNameError("Name must be a non-empty string");
  }

  return "Goodbye, " + trimmed_name + "!";
}

// Convenience functions using default Greeter instance
std::string Hello(const std::string& name) {
  return cpp_template::Greeter::Hello(name);
}

std::string Goodbye(const std::string& name) {
  return cpp_template::Greeter::Goodbye(name);
}

}  // namespace cpp_template
