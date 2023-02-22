if(NOT BUILD_SDK)
  return()
endif()

# main sdk
add_library(calculator SHARED calculator.cpp dir.cpp DLibrary.cpp
                              plugin_manager.cpp)
if(PLATFORM_ANDROID)
  add_subdirectory(sdk/android/calculator/src/main/cpp)
endif(PLATFORM_ANDROID)

if(PLATFORM_IOS)
  add_subdirectory(sdk/ios)
  add_custom_command(
    TARGET calculator
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory
            ${CMAKE_BINARY_DIR}/$<CONFIG>/calculator.framework/Headers
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_ROOT}/calculator/sdk/ios/CalculatorApple.h
            "${CMAKE_BINARY_DIR}/$<CONFIG>/calculator.framework/Headers")
endif()

target_include_directories(calculator PUBLIC ${PROJECT_ROOT}/calculator)
target_link_libraries(calculator ${CMAKE_DL_LIBS})
# set_target_properties(calculator PROPERTIES RUNTIME_OUTPUT_DIRECTORY
# ${CMAKE_BINARY_DIR})
if(PLATFORM_LINUX OR PLATFORM_ANDROID)
  set_target_properties(calculator PROPERTIES BUILD_RPATH $ORIGIN)
endif()

# libadd plugin
add_library(add SHARED libadd.h libadd.cpp)
if(PLATFORM_APPLE)
  target_apply_xcode_default_config(add)
  if(GEN_FRAMEWORK)
    set_target_properties(add PROPERTIES FRAMEWORK TRUE)
    target_set_xcode_property(add DEFINES_MODULE "YES")
    target_set_xcode_property(add PRODUCT_BUNDLE_IDENTIFIER "add")
  endif()
endif(PLATFORM_APPLE)

# libsub plugin
add_library(sub SHARED libsub.h libsub.cpp)
if(PLATFORM_APPLE)
  target_apply_xcode_default_config(sub)
  if(GEN_FRAMEWORK)
    set_target_properties(sub PROPERTIES FRAMEWORK TRUE)
    target_set_xcode_property(sub DEFINES_MODULE "YES")
    target_set_xcode_property(sub PRODUCT_BUNDLE_IDENTIFIER "sub")
  endif()
endif(PLATFORM_APPLE)

message(STATUS "CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
message(STATUS "CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
