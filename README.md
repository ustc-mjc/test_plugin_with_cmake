# Linux
> 一般不用IDE，编译管理器为make，编译器为gcc
1. 查看rpath
> linux上需要link dl库，也要为calculator库单独设置BUILD_RPATH属性
```
objdump -x build/demo/linux/main | grep PATH
-- RUNPATH              /home/mojucheng/learn_everything/test_plugin_with_cmake/build/calculator
objdump -x build/calculator/libcalculator.so | grep PATH
-- RUNPATH              $ORIGIN
```
# Mac
> 使用ios.cmake工具链
> 包管理器为CocoaPods
> 编译IDE为xcode，编译管理器为xcodebuild，编译器为clang
默认生成dylib, 如要生成framework需要设置cmake属性
1. 查看dylib的rpath
> mac上不用link dl库，也不用为calculator库单独设置BUILD_RPATH属性，demo便可运行
```
otool -L build/demo/mac/main | grep rpath
-- @rpath/libcalculator.dylib (compatibility version 0.0.0, current version 0.0.0)
otool -L build/calculator/libcalculator.dylib | grep rpath 
-- @rpath/libcalculator.dylib (compatibility version 0.0.0, current version 0.0.0)
```
2. mac 特有的库或者app需要使用苹果的cmake工具链
# Windows
> 编译IDE一般为Visual Studio，编译管理器为msbuild，编译器一般为msvc
1. 查看dll的rpath
> 注意windows上默认生成的dll库不带lib前缀
```
dumpbin
```
# iOS
> 使用ios.cmake工具链
> 包管理器为CocoaPods
> 编译IDE为xcode，编译管理器为xcodebuild，编译器为clang
```
cmake -GXcode -Bbuild_ios -DPLATFORM=OS64COMBINED -DTARGET_PLATFORM=ios
```
## 库
默认会编译dylib和dylib.dSYM

# Android
> 包管理器为maven
> 编译IDE为Android Studio，编译管理器为gradle，编译器为clang、jdk
> 与Linux一样需要给target设置 BUILD_RPATH属性为$ORIGIN，否则找不到插件，其他gradle会搞定

---
---
---
# cmake设置输出路径
> 发现cmake生成IDE工程才能使设置的输出路径生效, android无需设置，由gradle管理
```
if (NOT PLATFORM_ANDROID)
    foreach(build_type ${CMAKE_CONFIGURATION_TYPES})
        message(STATUS "Set output dir for ${build_type}")
        string(TOUPPER "${build_type}" upper_build_type)
        set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${upper_build_type} ${CMAKE_BINARY_DIR}/${build_type})
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${upper_build_type} ${CMAKE_BINARY_DIR}/${build_type})
        set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${upper_build_type} ${CMAKE_BINARY_DIR}/${build_type})
    endforeach()
endif()
```