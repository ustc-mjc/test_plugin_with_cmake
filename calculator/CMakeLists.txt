if(NOT BUILD_SDK)
  return()
endif()

set(SDK_TARGET_NAME calculator)
# main sdk
add_library(${SDK_TARGET_NAME} SHARED calculator.cpp dir.cpp DLibrary.cpp
                                      plugin_manager.cpp)
if(PLATFORM_ANDROID)
  add_subdirectory(sdk/android/calculator/src/main/cpp)
endif(PLATFORM_ANDROID)

if(PLATFORM_IOS)
  add_subdirectory(sdk/ios)
  add_custom_command(
    TARGET ${SDK_TARGET_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory
            ${CMAKE_BINARY_DIR}/$<CONFIG>/${SDK_TARGET_NAME}.framework/Headers
    COMMAND
      ${CMAKE_COMMAND} -E copy
      ${PROJECT_ROOT}/calculator/sdk/ios/CalculatorApple.h
      "${CMAKE_BINARY_DIR}/$<CONFIG>/${SDK_TARGET_NAME}.framework/Headers")
  set(IOS_SDK_ARCHIVE_OUTPUT_PATH
      ${CMAKE_BINARY_DIR}/${SDK_TARGET_NAME}_ios/output)
  add_custom_command(
    TARGET ${SDK_TARGET_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${IOS_SDK_ARCHIVE_OUTPUT_PATH}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${IOS_SDK_ARCHIVE_OUTPUT_PATH}
    COMMAND zip -q -r ${SDK_TARGET_NAME}.zip *
    COMMAND ${CMAKE_COMMAND} -E copy ${SDK_TARGET_NAME}.zip
            ${IOS_SDK_ARCHIVE_OUTPUT_PATH}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>)
endif()

target_include_directories(${SDK_TARGET_NAME} PUBLIC ${PROJECT_ROOT}/calculator)
# link dlopen
target_link_libraries(${SDK_TARGET_NAME} ${CMAKE_DL_LIBS})
# set_target_properties(calculator PROPERTIES RUNTIME_OUTPUT_DIRECTORY
# ${CMAKE_BINARY_DIR})
if(PLATFORM_LINUX OR PLATFORM_ANDROID)
  set_target_properties(${SDK_TARGET_NAME} PROPERTIES BUILD_RPATH $ORIGIN)
endif()

# libadd plugin
add_library(add SHARED libadd.h libadd.cpp)
if(PLATFORM_APPLE)
  target_apply_xcode_default_config(add)
  if(GEN_FRAMEWORK)
    set_target_properties(add PROPERTIES FRAMEWORK TRUE)
    target_set_xcode_property(add DEFINES_MODULE "YES")
    target_set_xcode_property(add PRODUCT_BUNDLE_IDENTIFIER "add")
    # not need code sign
    set_target_properties(
      add PROPERTIES XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ""
                     XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS "")
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
    # not need code sign
    set_target_properties(
      sub PROPERTIES XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ""
                     XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS "")
  endif()
endif(PLATFORM_APPLE)

add_dependencies(${SDK_TARGET_NAME} add sub)
message(STATUS "CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
message(STATUS "CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
