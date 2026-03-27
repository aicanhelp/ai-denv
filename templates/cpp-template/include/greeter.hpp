/**
 * @file greeter.hpp
 * @brief Greeter module demonstrating clean function design and documentation
 * @author Templ Project
 * @date 2025-09-09
 *
 * Following Google C++ Style Guide conventions for header design
 */

#ifndef CPP_TEMPLATE_GREETER_HPP_
#define CPP_TEMPLATE_GREETER_HPP_

#include <stdexcept>
#include <string>
#include <string_view>

namespace cpp_template {

/**
 * @brief Exception thrown when invalid name is provided to greeting functions
 */
class InvalidNameError : public std::invalid_argument {
 public:
  explicit InvalidNameError(const std::string& message)
      : std::invalid_argument(message) {}
};

/**
 * @brief A Greeter class that provides greeting and farewell functionality
 *
 * Demonstrates proper class structure following Google C++ Style Guide.
 * This class provides methods for creating greeting and farewell messages.
 */
class Greeter {
 public:
  /**
   * @brief Default constructor
   */
  Greeter() = default;

  /**
   * @brief Creates a greeting message for the specified name
   *
   * @param name The name to greet (must be non-empty)
   * @return std::string A formatted greeting message
   * @throws InvalidNameError When name is empty or only whitespace
   *
   * Example usage:
   * @code
   * Greeter greeter;
   * std::string message = greeter.Hello("World");
   * // Returns: "Hello, World!"
   * @endcode
   */
  static std::string Hello(const std::string& name);

  /**
   * @brief Creates a farewell message for the specified name
   *
   * @param name The name to bid farewell (must be non-empty)
   * @return std::string A formatted farewell message
   * @throws InvalidNameError When name is empty or only whitespace
   *
   * Example usage:
   * @code
   * Greeter greeter;
   * std::string message = greeter.Goodbye("World");
   * // Returns: "Goodbye, World!"
   * @endcode
   */
  static std::string Goodbye(const std::string& name);
};

/**
 * @brief Convenience function that creates a greeting message
 *
 * Uses a default Greeter instance for convenient standalone usage.
 *
 * @param name The name to greet (must be non-empty)
 * @return std::string A formatted greeting message
 * @throws InvalidNameError When name is empty or only whitespace
 *
 * Example usage:
 * @code
 * std::string message = Hello("World");
 * // Returns: "Hello, World!"
 *
 * std::string message2 = Hello("C++");
 * // Returns: "Hello, C++!"
 * @endcode
 */
std::string Hello(const std::string& name);

/**
 * @brief Convenience function that creates a farewell message
 *
 * Uses a default Greeter instance for convenient standalone usage.
 *
 * @param name The name to bid farewell (must be non-empty)
 * @return std::string A formatted farewell message
 * @throws InvalidNameError When name is empty or only whitespace
 *
 * Example usage:
 * @code
 * std::string message = Goodbye("World");
 * // Returns: "Goodbye, World!"
 * @endcode
 */
std::string Goodbye(const std::string& name);

/**
 * @brief Utility function to trim whitespace from string
 *
 * Uses string_view for zero-copy performance (C++17).
 *
 * @param str The string to trim
 * @return std::string_view A view of the trimmed string
 */
std::string_view Trim(std::string_view str);

}  // namespace cpp_template

#endif  // CPP_TEMPLATE_GREETER_HPP_
