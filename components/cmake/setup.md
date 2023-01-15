 
 ### pkg-config
 对于支持pkg-config工具的库来说，库文件的搜索路径实际就是对.pc文件的搜索路径，一般系统的默认搜索路在/usr/lib/pkgconfig 中，
 库的头文件一般在/usr/include中。而个人使用的第三方库，不能每次编译后都装到/usr目录下吧。
 所以私有工程在编译链接第三方库时可以通过环境变量PKG_CONFIG_PATH来设置，pkg-config工具将按照设置路径的先后顺序进行搜索，直到找到指定的.pc文件为止。
 
find_package 方式查找，依赖*.cmake文件

pkg_search_module方式查找，依赖.pc文件

