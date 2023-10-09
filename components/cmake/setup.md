 
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

## cmake_build_type
### 一、cmake_build_type的概念  
在使用CMake进行项目构建时，需要设置cmake_build_type参数。通俗的说，build_type就是指定目标文件的编译选项，以决定编译出来的程序是一个可执行文件还是一个库文件，以及是否开启调试信息等等。

CMake支持以下三种build_type:

- Debug：开启所有的调试信息，不进行编译器优化；
- Release: 关闭所有的调试信息，打开带优化的编译器选项；
- RelWithDebInfo: 关闭部分调试信息，开启带优化的编译器选项。

### 二、Debug选项对应的编译器选项  
使用Debug选项，会开启所有的调试信息，不进行编译器优化，对应的编译选项如下:

- O0：不开启任何优化选项；  
- g：生成调试信息；  
- fno-inline：禁止内联函数，以便在调试时对每个函数进行独立跟踪。  

Debug选项开启了所有的调试信息，对调试非常有帮助，但对编译器优化会影响较大，编译出来的程序不够高效。

### 三、Release选项对应的编译器选项
使用Release选项，关闭所有的调试信息，打开带优化的编译器选项，对应的编译选项如下:

- O3: 优化选项，开启编译器全部优化选项； 
- s: 删除调试信息； 
- finline-functions: 函数内联优化。 
使用Release选项，可以得到高效率的可执行文件，但是对于调试来说不利于问题定位。

### 四、RelWithDebInfo选项对应的编译器选项  
使用RelWithDebInfo选项，关闭部分调试信息，开启带优化的编译器选项，对应的编译选项如下:

- O2: 开启编译器部分优化选项；  
- g: 生成调试信息。  
使用RelWithDebInfo选项，既有优秀的执行效果，又有一些调试信息，可以方便快速找到问题的源头。

### 五、CMake中的build_type设置
在CMakeLists.txt文件中，设置cmake_build_type的方法如下：

- CMAKE_BUILD_TYPE选项可以使用如下命令进行设置：
- SET(CMAKE_BUILD_TYPE Debug)。
默认情况下，cmake_build_type的值为None，即不会进行编译优化和调试信息的生成。需要进行调试信息生成的时候，需要手动设置。

### 六、cmake_build_type变量的影响
Clion中也有有关这个选项。

cmake_build_type选项会影响到CMake的一些行为，比如默认的编译器选项、缺省目标文件扩展名、缺省安装路径、缺省编译器错误处理选项等等。

在CMakeLists.txt文件中可以使用如下表达式，获取当前的build_type:
```text
IF(${CMAKE_BUILD_TYPE} MATCHES Debug)
  MESSAGE(STATUS "Debug mode")
ELSEIF(${CMAKE_BUILD_TYPE} MATCHES Release)
  MESSAGE(STATUS "Release mode")
ELSEIF(${CMAKE_BUILD_TYPE} MATCHES RelWithDebInfo)
  MESSAGE(STATUS "RelWithDebInfo mode")
ELSE()
  MESSAGE(STATUS "None mode")
ENDIF()
```

七、总结
cmake_build_type选项对于CMake的项目构建非常关键，可以决定编译生成的文件的一系列行为。在进行项目构建时，需要根据实际情况进行设置。
