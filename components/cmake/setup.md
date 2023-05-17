 
 ### pkg-config
 对于支持pkg-config工具的库来说，库文件的搜索路径实际就是对.pc文件的搜索路径，一般系统的默认搜索路在/usr/lib/pkgconfig 中，
 库的头文件一般在/usr/include中。而个人使用的第三方库，不能每次编译后都装到/usr目录下吧。
 所以私有工程在编译链接第三方库时可以通过环境变量PKG_CONFIG_PATH来设置，pkg-config工具将按照设置路径的先后顺序进行搜索，直到找到指定的.pc文件为止。
 
find_package 方式查找，依赖*.cmake文件

pkg_search_module方式查找，依赖.pc文件


find_package () 主要用于查找并配置复杂的第三方软件包，这些软件包通常包含多个库和头文件，并且可能需要执行额外的配置步骤。
例如，对于 Boost 库，你需要使用 find_package () 来查找和配置 Boost，CMake 会查找 Boost 库的位置，并设置正确的库路径、头文件路径和编译选项等。

find_library ()则主要用于查找单个库文件。如果你只需要使用某个库文件而不需要配置整个第三方软件包，那
么可以使用 find_library ()来查找该库文件并设置库路径、链接选项等。

因此，find_package ()和 find_library ()主要用于不同的场景，它们的使用方式也略有不同。在使用时，需要根据具体情况选择合适的函数来查找和配置库文件。
