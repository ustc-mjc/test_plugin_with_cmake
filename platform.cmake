# CopyRight (c) 2020 ByteDance Inc. All Right Reserved.
# Platform check
#  Export Cache Variables(access vir get_cache):
#   HOST_WINDOWS: BOOL
#   HOST_MACOS: BOOL
#   HOST_LINUX: BOOL
#   PLATFORM: string, input from command line or auto select according to the host(ios,macos,android,unity,linux,win,windows)
#   PLATFORM_IOS: BOOL
#   PLATFORM_MAC: BOOL
#   PLATFORM_ANDROID: BOOL
#   PLATFORM_WINDOWS: BOOL
#   PLATFORM_LINUX: BOOL
#   PLATFORM_UNITY: BOOL
#   ARCHITECTURE_NAME: string, define by HOST_<PLATFORM>
#   RUNTIME_NAME: string, example: powershell bash zsh and so on

# Check current platform
set(HOST_WINDOWS FALSE)
set(HOST_MACOS FALSE)
set(HOST_LINUX FALSE)

if ("x${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "xWindows")
    set(HOST_WINDOWS TRUE)
    message(STATUS "Compile host: Windows")
elseif ("x${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "xDarwin")
    set(HOST_MACOS TRUE)
    message(STATUS "Compile host: MacOS")
elseif ("x${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "xLinux")
    set(HOST_LINUX TRUE)
    message(STATUS "Compile host: Linux")
else()
    message(WARNING "Cannot recognized compile host, set default to Linux")
    set(HOST_LINUX TRUE)
endif()

if (ANDROID)
    set(PLATFORM "android")
else()
    if (HOST_MACOS AND (NOT PLATFORM))
        message(STATUS "not specified platform, guess to create macos")
        set(PLATFORM "macos")
    endif()

    # Current host is mac osx, and not compile android, not select
    # ios or mac, which should be an fatal error
    if (HOST_MACOS AND
    (NOT "x${PLATFORM}" STREQUAL "xios") AND
    (NOT "x${PLATFORM}" STREQUAL "xmacos") AND
    (NOT "x${PLATFORM}" STREQUAL "xmac") AND
    (NOT "x${PLATFORM}" STREQUAL "xandroid") AND
    (NOT "x${PLATFORM}" STREQUAL "xunity")
            )
        message(FATAL_ERROR "Please set PLATFORM as ios or macos")
    endif()
endif()

# for other platform and set the default platform according to its host name
if (NOT PLATFORM)
    if (HOST_LINUX)
        set(PLATFORM "linux")
    elseif(HOST_WINDOWS)
        set(PLATFORM "windows")
    endif()
    # Don't need to check macos
endif()

set(PLATFORM_IOS FALSE)
set(PLATFORM_ANDROID FALSE)
set(PLATFORM_MAC FALSE)
set(PLATFORM_LINUX FALSE)
set(PLATFORM_WINDOWS FALSE)
set(PLATFORM_APPLE FALSE)
set(PLATFORM_UNITY FALSE)
set(PLATFORM_POSIX FALSE)

if ("x${PLATFORM}" STREQUAL "xios")
    set(PLATFORM_IOS TRUE)
    set(PLATFORM_APPLE TRUE)
    set(PLATFORM_POSIX TRUE)
    add_definitions(-DPLATFORM_IOS=1)
elseif(("x${PLATFORM}" STREQUAL "xmacos") OR ("x${PLATFORM}" STREQUAL "xmac"))
    set(PLATFORM "macos")
    set(PLATFORM_MAC TRUE)
    set(PLATFORM_APPLE TRUE)
    set(PLATFORM_POSIX TRUE)
    add_definitions(-DPLATFORM_MAC=1)
elseif("x${PLATFORM}" STREQUAL "xandroid")
    set(PLATFORM_ANDROID TRUE)
    set(PLATFORM_POSIX TRUE)
    add_definitions(-DPLATFORM_ANDROID=1)
elseif(("x${PLATFORM}" STREQUAL "xwindows") OR ("x${PLATFORM}" STREQUAL "xwin"))
#    if(CMAKE_SIZEOF_VOID_P EQUAL 8 OR CMAKE_CL_64)
    set(PLATFORM "windows")
    set(PLATFORM_WINDOWS TRUE)
    add_definitions(-DPLATFORM_WINDOWS=1)
else()
    set(PLATFORM_LINUX TRUE)
    set(PLATFORM_POSIX TRUE)
    add_definitions(-DPLATFORM_LINUX=1)
endif()

set(ARCHITECTURE_AARCH64 FALSE)
set(ARCHITECTURE_AMD64 FALSE)
set(ARCHITECTURE_WIN32 FALSE)
set(ARCHITECTURE_WIN64 FALSE)

if (PLATFORM_LINUX OR PLATFORM_MAC)
    execute_process(
            COMMAND uname -m
            OUTPUT_VARIABLE architecture
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if ("x${architecture}" STREQUAL "xaarch64")
        set(ARCHITECTURE_AARCH64 TRUE)
    elseif("x${architecture}" STREQUAL "xarm64")
        set(ARCHITECTURE_AARCH64 TRUE)
    else()
        set(ARCHITECTURE_AMD64 TRUE)
    endif()
    set(ARCHITECTURE_NAME ${architecture})
elseif(PLATFORM_WINDOWS)
    if(CMAKE_CL_64)
        set(ARCHITECTURE_WIN64 TRUE)
        set(ARCHITECTURE_NAME "win64")
    else()
        set(ARCHITECTURE_WIN32 TRUE)
        set(ARCHITECTURE_NAME "win32")
    endif()
endif()

# check runtime
set(RUNTIME_POWERSHELL FALSE)
set(RUNTIME_POWERSHELL_CORE FALSE)
set(RUNTIME_CMD FALSE)
set(RUNTIME_BASH FALSE)
set(RUNTIME_ZSH FALSE)
set(RUNTIME_FISH FALSE)
set(RUNTIME_CSH FALSE)
set(RUNTIME_NAME "")

if(HOST_WINDOWS)
    execute_process(
            COMMAND "$PSVersionTable.PSEdition"
            RESULT_VARIABLE POWERSHELL_CHECK_RESULT
            OUTPUT_VARIABLE POWERSHELL_EDITION
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if(NOT "x${POWERSHELL_CHECK_RESULT}" STREQUAL "x0")
        set(RUNTIME_CMD TRUE)
        set(RUNTIME_NAME "cmd")
    else()
        if ("x${POWERSHELL_EDITION}" STREQUAL "xCore")
            set(RUNTIME_POWERSHELL_CORE TRUE)
            set(RUNTIME_NAME "powershell core")
        else()
            set(RUNTIME_POWERSHELL TRUE)
            set(RUNTIME_NAME "powershell")
        endif()
    endif()
else()
    set(SHELL_EXECUTE_PATH $ENV{SHELL})
    if("x${SHELL_EXECUTE_PATH}" STREQUAL "x")
        set(SHELL_EXECUTE_PATH "/bin/bash")
    endif()
    string(REPLACE "." ";" SHELL_EXECUTE_PATH_PARTS "${SHELL_EXECUTE_PATH}")
    list(GET SHELL_EXECUTE_PATH_PARTS -1 SHELL_NAME)
    if ("x${SHELL_NAME}" STREQUAL "xbash")
        set(RUNTIME_BASH TRUE)
        set(RUNTIME_NAME "bash")
    elseif("x${SHELL_NAME}" STREQUAL "xzsh")
        set(RUNTIME_ZSH TRUE)
        set(RUNTIME_NAME "zsh")
    elseif("x${SHELL_NAME}" STREQUAL "xfish")
        set(RUNTIME_FISH TRUE)
        set(RUNTIME_NAME "fish")
    elseif("x${SHELL_NAME}" STREQUAL "xcsh")
        set(RUNTIME_CSH TRUE)
        set(RUNTIME_NAME "csh")
    else()
        message(STATUS "cannot detect which shell is using, guess to be bash")
        set(RUNTIME_BASH TRUE)
        set(RUNTIME_NAME "bash")
    endif()
endif()

message(STATUS "PLATFORM: ${PLATFORM}")
message(STATUS "ARCHITECTURE_NAME: ${ARCHITECTURE_NAME}")
message(STATUS "RUNTIME_NAME: ${RUNTIME_NAME}")
