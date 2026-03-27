/**
 * @file test_greeter.cpp
 * @brief Test suite for the greeter module using Google Test
 * @author Templ Project
 * @date 2025-09-09
 *
 * Demonstrates TDD practices using Google Test framework
 */

#include <gtest/gtest.h>

#include "greeter.hpp"

namespace cpp_template {
namespace {

// Test fixture for greeter functions
class GreeterTest : public ::testing::Test {
 protected:
  void SetUp() override {
    // Setup code if needed
  }

  void TearDown() override {
    // Cleanup code if needed
  }
};

// Tests for Hello function
TEST_F(GreeterTest, HelloReturnsGreetingForValidName) {
  const std::string result = Hello("World");
  EXPECT_EQ(result, "Hello, World!");
}

TEST_F(GreeterTest, HelloHandlesNamesWithWhitespace) {
  const std::string result = Hello("  C++  ");
  EXPECT_EQ(result, "Hello, C++!");
}

TEST_F(GreeterTest, HelloThrowsForEmptyString) {
  EXPECT_THROW(Hello(""), InvalidNameError);
}

TEST_F(GreeterTest, HelloThrowsForWhitespaceOnlyString) {
  EXPECT_THROW(Hello("   "), InvalidNameError);
  EXPECT_THROW(Hello("\t\n"), InvalidNameError);
}

TEST_F(GreeterTest, HelloHandlesSpecialCharacters) {
  const std::string result = Hello("C++20");
  EXPECT_EQ(result, "Hello, C++20!");
}

// Tests for Goodbye function
TEST_F(GreeterTest, GoodbyeReturnsGreetingForValidName) {
  const std::string result = Goodbye("World");
  EXPECT_EQ(result, "Goodbye, World!");
}

TEST_F(GreeterTest, GoodbyeHandlesNamesWithWhitespace) {
  const std::string result = Goodbye("  C++  ");
  EXPECT_EQ(result, "Goodbye, C++!");
}

TEST_F(GreeterTest, GoodbyeThrowsForEmptyString) {
  EXPECT_THROW(Goodbye(""), InvalidNameError);
}

TEST_F(GreeterTest, GoodbyeThrowsForWhitespaceOnlyString) {
  EXPECT_THROW(Goodbye("   "), InvalidNameError);
  EXPECT_THROW(Goodbye("\t\n"), InvalidNameError);
}

// Tests for Trim utility function
TEST_F(GreeterTest, TrimRemovesLeadingAndTrailingWhitespace) {
  EXPECT_EQ(Trim("  hello  "), "hello");
  EXPECT_EQ(Trim("\t\nworld\t\n"), "world");
  EXPECT_EQ(Trim("C++"), "C++");
}

TEST_F(GreeterTest, TrimHandlesEmptyAndWhitespaceStrings) {
  EXPECT_EQ(Trim(""), "");
  EXPECT_EQ(Trim("   "), "");
  EXPECT_EQ(Trim("\t\n"), "");
}

// Exception tests
TEST_F(GreeterTest, InvalidNameErrorIsStdInvalidArgument) {
  try {
    Hello("");
    FAIL() << "Expected InvalidNameError to be thrown";
  } catch (const InvalidNameError& e) {
    EXPECT_STREQ(e.what(), "Name must be a non-empty string");
  } catch (const std::invalid_argument& e) {
    // InvalidNameError should be a std::invalid_argument
    EXPECT_STREQ(e.what(), "Name must be a non-empty string");
  }
}

// Test fixture for Greeter class
class GreeterClassTest : public ::testing::Test {
 protected:
  Greeter greeter;
};

// Tests for Greeter class Hello method
TEST_F(GreeterClassTest, HelloReturnsGreetingForValidName) {
  const std::string result = Greeter::Hello("World");
  EXPECT_EQ(result, "Hello, World!");
}

TEST_F(GreeterClassTest, HelloHandlesNamesWithWhitespace) {
  const std::string result = Greeter::Hello("  C++  ");
  EXPECT_EQ(result, "Hello, C++!");
}

TEST_F(GreeterClassTest, HelloThrowsForEmptyString) {
  EXPECT_THROW(greeter.Hello(""), InvalidNameError);
}

TEST_F(GreeterClassTest, HelloThrowsForWhitespaceOnlyString) {
  EXPECT_THROW(greeter.Hello("   "), InvalidNameError);
  EXPECT_THROW(greeter.Hello("\t\n"), InvalidNameError);
}

TEST_F(GreeterClassTest, HelloHandlesSpecialCharacters) {
  const std::string result = Greeter::Hello("C++20");
  EXPECT_EQ(result, "Hello, C++20!");
}

// Tests for Greeter class Goodbye method
TEST_F(GreeterClassTest, GoodbyeReturnsGreetingForValidName) {
  const std::string result = Greeter::Goodbye("World");
  EXPECT_EQ(result, "Goodbye, World!");
}

TEST_F(GreeterClassTest, GoodbyeHandlesNamesWithWhitespace) {
  const std::string result = Greeter::Goodbye("  C++  ");
  EXPECT_EQ(result, "Goodbye, C++!");
}

TEST_F(GreeterClassTest, GoodbyeThrowsForEmptyString) {
  EXPECT_THROW(greeter.Goodbye(""), InvalidNameError);
}

TEST_F(GreeterClassTest, GoodbyeThrowsForWhitespaceOnlyString) {
  EXPECT_THROW(greeter.Goodbye("   "), InvalidNameError);
  EXPECT_THROW(greeter.Goodbye("\t\n"), InvalidNameError);
}

// Test that convenience functions use the same logic as class methods
TEST_F(GreeterClassTest, ConvenienceFunctionsMatchClassMethods) {
  EXPECT_EQ(Hello("World"), Greeter::Hello("World"));
  EXPECT_EQ(Goodbye("World"), Greeter::Goodbye("World"));
}

}  // namespace
}  // namespace cpp_template

int main(int argc, char** argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
