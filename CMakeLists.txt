cmake_minimum_required(VERSION 3.24)

# Disable in-source build to prevent source tree corruption
if("x${CMAKE_SOURCE_DIR}" STREQUAL "x${CMAKE_BINARY_DIR}")
    message(FATAL_ERROR "FATAL: In-source build is not allowed.
		You should create a separate directory for build files.")
endif()

project(test_plugin)

set(CMAKE_CXX_STANDARD 11)

# For IDE
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# For shared lib
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Do not create a zero_check target
set(CMAKE_SUPPRESS_REGENERATION TRUE)

# Set CMAKE_BUILD_TYPE
set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configs" FORCE)
if(NOT DEFINED CMAKE_BUILD_TYPE)
    message(STATUS "'Debug' build type is used by default. Use CMAKE_BUILD_TYPE to specify build type (Release or Debug)")
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build")
endif()

set(PROJECT_ROOT ${CMAKE_CURRENT_SOURCE_DIR})
# hidden symbol
set(CMAKE_CXX_VISIBILITY_PRESET hidden)

# detect platform
include(platform.cmake)
# define option
include(options.cmake)

# set lib output path
if (NOT PLATFORM_ANDROID)
    foreach(build_type ${CMAKE_CONFIGURATION_TYPES})
        message(STATUS "Set output dir for ${build_type}")
        string(TOUPPER "${build_type}" upper_build_type)
        set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${upper_build_type} ${CMAKE_BINARY_DIR}/${build_type})
        set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${upper_build_type} ${CMAKE_BINARY_DIR}/${build_type})
        set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${upper_build_type} ${CMAKE_BINARY_DIR}/${build_type})
    endforeach()
endif()

# set(INSTALL_LIB_DIR "${PROJECT_BINARY_DIR}/lib") # 假设安装目录在编译目录的lib子目录内
 
set(CMAKE_SKIP_BUILD_RPATH FALSE)  
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
# set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")  
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)


add_subdirectory(calculator)
add_subdirectory(demo)

message(STATUS "CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
message(STATUS "CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")