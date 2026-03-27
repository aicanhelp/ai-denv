# Classes

Complete list of all classes in the C++ Template project.

For the full class list and hierarchy, see:

- [All Classes](../cpp-template/classes.md) - Alphabetical list of all classes
- [Class Hierarchy](../cpp-template/hierarchy.md) - Inheritance relationships

## Core Classes

### [Greeter](../cpp-template/classcpp__template_1_1_greeter.md)

A Greeter class that provides greeting and farewell functionality. Demonstrates proper class structure following Google C++ Style Guide.

**Static Methods:**

- `Hello(const std::string& name)` - Creates a greeting message
- `Goodbye(const std::string& name)` - Creates a farewell message

### [InvalidNameError](../cpp-template/classcpp__template_1_1_invalid_name_error.md)

Exception thrown when invalid name is provided to greeting functions. Inherits from `std::runtime_error`.
