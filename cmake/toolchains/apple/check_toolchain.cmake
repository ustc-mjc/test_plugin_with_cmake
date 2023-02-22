cmake_minimum_required (VERSION 3.2)
enable_testing()

enable_language(CXX)
enable_language(OBJC)

MESSAGE( STATUS "CMAKE_CXX_FLAGS: " ${CMAKE_CXX_FLAGS} )
MESSAGE( STATUS "CMAKE_OBJC_FLAGS: " ${CMAKE_OBJC_FLAGS} )

# Add some sanitary checks that the toolchain is actually working!
include(CheckCXXSymbolExists)
check_cxx_symbol_exists(kqueue sys/event.h HAVE_KQUEUE)
if(NOT HAVE_KQUEUE)
  message(STATUS "kqueue NOT found!")
else()
  message(STATUS "kqueue found!")
endif()

# for macos
find_library(APPKIT_LIBRARY AppKit)
if (NOT APPKIT_LIBRARY)
  message(STATUS "AppKit.framework NOT found!")
else()
  message(STATUS "AppKit.framework found! ${APPKIT_LIBRARY}")
endif()

# common
find_library(FOUNDATION_LIBRARY Foundation)
if (NOT FOUNDATION_LIBRARY)
  message(STATUS "Foundation.framework NOT found!")
else()
  message(STATUS "Foundation.framework found! ${FOUNDATION_LIBRARY}")
endif()

# for ios
find_library(UIKIT_LIBRARY UIKit)
if (NOT UIKIT_LIBRARY)
  message(STATUS "UIKit.framework NOT found!")
else()
  message(STATUS "UIKit.framework found! ${UIKIT_LIBRARY}")
endif()

# Hook up XCTest for the supported plaforms (all but WatchOS)
if(NOT PLATFORM MATCHES ".*WATCHOS.*")
  # Use the standard find_package, broken between 3.14.0 and 3.14.4 at least for XCtest...
  find_package(XCTest)
  # Fallback: Try to find XCtest as host package via toochain macro (should always work)
  find_host_package(XCTest REQUIRED)
endif()

# Make sure try_compile() works
# include(CheckTypeSize)
# check_type_size(time_t SIZEOF_TIME_T)