if(NOT BUILD_CLI_DEMO AND NOT BUILD_UI_DEMO)
  return()
endif()

if(BUILD_CLI_DEMO)
  if(PLATFORM_MAC)
    add_subdirectory(mac)
  elseif(PLATFORM_WINDOWS)
    add_subdirectory(windows)
  elseif(PLATFORM_LINUX)
    add_subdirectory(linux)
  endif()
endif()

if(BUILD_UI_DEMO)
  if(PLATFORM_ANDROID)

  elseif(PLATFORM_IOS)
    add_subdirectory(ios)
  endif()

endif()
