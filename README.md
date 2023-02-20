# Linux
1. 查看rpath
> linux上需要link dl库，也要为calculator库单独设置BUILD_RPATH属性
```
objdump -x build/demo/linux/main | grep PATH
-- RUNPATH              /home/mojucheng/learn_everything/test_plugin_with_cmake/build/calculator
objdump -x build/calculator/libcalculator.so | grep PATH
-- RUNPATH              $ORIGIN
```
# Mac
1. 查看dylib的rpath
> mac上不用link dl库，也不用为calculator库单独设置BUILD_RPATH属性，demo便可运行
```
otool -L build/demo/mac/main | grep rpath
-- @rpath/libcalculator.dylib (compatibility version 0.0.0, current version 0.0.0)
otool -L build/calculator/libcalculator.dylib | grep rpath 
-- @rpath/libcalculator.dylib (compatibility version 0.0.0, current version 0.0.0)
```
# Windows
1. 查看dll的rpath
