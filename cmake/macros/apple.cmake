# CopyRight (c) 2020 ByteDance Inc. All Right Reserved.
# Macro for Apple(iOS and Mac)
#   target_set_xcode_property
#   rtc_target_apply_xcode_default_config
#   rtc_copy_framework
#   rtc_copy_dylib

cmake_minimum_required(VERSION 3.15.0)

# This little macro lets you set any Xcode specific property.
# param: target property value
# param: target property value rel<All|Debug|Release>
macro(target_set_xcode_property)
  if (PLATFORM_APPLE)
    set(extra_macro_args ${ARGN})
    list(LENGTH extra_macro_args num_args)
    if ( ${num_args} LESS 3 )
      message(FATAL_ERROR "target_set_xcode_property need at least 3 arguments: target property value")
    endif()

    list(GET extra_macro_args 0 TARGET)
    list(GET extra_macro_args 1 XCODE_PROPERTY)
    list(GET extra_macro_args 2 XCODE_VALUE)

    if ( ${num_args} EQUAL 4 )
      list(GET extra_macro_args 3 _rel_)
    elseif( ${num_args} EQUAL 3 )
      set(_rel_ "All")
    endif()

    if("${_rel_}" STREQUAL "All")
      foreach(build_type ${CMAKE_CONFIGURATION_TYPES})
        set_target_properties(${TARGET} PROPERTIES
          XCODE_ATTRIBUTE_${XCODE_PROPERTY}[variant=${build_type}] "${XCODE_VALUE}")
      endforeach()      
      set_target_properties(${TARGET} PROPERTIES
        XCODE_ATTRIBUTE_${XCODE_PROPERTY} "${XCODE_VALUE}")
    else()
      set_target_properties(${TARGET} PROPERTIES
        XCODE_ATTRIBUTE_${XCODE_PROPERTY}[variant=${_rel_}] "${XCODE_VALUE}")
    endif()
  endif()
endmacro()

macro(target_get_xcode_property)
  if (PLATFORM_APPLE)
    set(extra_macro_args ${ARGN})
    list(LENGTH extra_macro_args num_args)
    if ( ${num_args} LESS 3 )
      message(FATAL_ERROR "rtc_target_get_xcode_property need at least 3 arguments: output_value target property")
    endif()

    list(GET extra_macro_args 0 output_value)
    list(GET extra_macro_args 1 TARGET)
    list(GET extra_macro_args 2 XCODE_PROPERTY)

    if ( ${num_args} EQUAL 4 )
      list(GET extra_macro_args 3 _rel_)
    elseif( ${num_args} EQUAL 3 )
      set(_rel_ "All")
    endif()

    if("${_rel_}" STREQUAL "All")
      get_target_property(${output_value} 
        ${TARGET} XCODE_ATTRIBUTE_${XCODE_PROPERTY})
    else()
      get_target_property(${output_value}
        ${TARGET} XCODE_ATTRIBUTE_${XCODE_PROPERTY}[variant=${_rel_}])
    endif()
  endif()
endmacro()

macro(target_apply_xcode_default_config target)
  if (PLATFORM_APPLE AND (${CMAKE_GENERATOR} STREQUAL "Xcode"))
    target_set_xcode_property(${target} CLANG_CXX_LANGUAGE_STANDARD "gnu++14")
    target_set_xcode_property(${target} CLANG_CXX_LIBRARY "libc++")
    target_set_xcode_property(${target} GCC_INLINES_ARE_PRIVATE_EXTERN "YES")
    target_set_xcode_property(${target} GCC_SYMBOLS_PRIVATE_EXTERN "YES")
    target_set_xcode_property(${target} DYLIB_COMPATIBILITY_VERSION 1)
    target_set_xcode_property(${target} DYLIB_INSTALL_NAME_BASE "@rpath")
    target_set_xcode_property(${target} STRIPFLAGS "-x" Release)
    target_set_xcode_property(${target} DEPLOYMENT_POSTPROCESSING "NO" Debug)
    target_set_xcode_property(${target} DEPLOYMENT_POSTPROCESSING "YES" Release)
    target_set_xcode_property(${target} COPY_PHASE_STRIP "NO" Debug)
    target_set_xcode_property(${target} STRIP_INSTALLED_PRODUCT "NO" Debug)
    target_set_xcode_property(${target} STRIP_STYLE "debugging" Debug)
    target_set_xcode_property(${target} STRIP_SWIFT_SYMBOLS "NO" Debug)
    target_set_xcode_property(${target} DEBUG_INFORMATION_FORMAT "dwarf-with-dsym")
    target_set_xcode_property(${target} DEFINES_MODULE "YES")
    target_set_xcode_property(${target} FRAMEWORK_SEARCH_PATHS "$(inherited)")
    target_set_xcode_property(${target} ENABLE_STRICT_OBJC_MSGSEND "YES")
    # target_set_xcode_property(${target} GCC_OPTIMIZATION_LEVEL "${RTC_OPTIMIZE_LEVEL}" Release)
    if (NOT BUILD_STATIC_LIB)
      target_set_xcode_property(${target} DYLIB_CURRENT_VERSION "1")

      target_set_xcode_property(${target} COPY_PHASE_STRIP "YES" Release)
      target_set_xcode_property(${target} STRIP_INSTALLED_PRODUCT "YES" Release)
      target_set_xcode_property(${target} STRIP_STYLE "non-global" Release)
      target_set_xcode_property(${target} STRIP_SWIFT_SYMBOLS "YES" Release)
    else()
      # the main binary that uses the static version of ByteRTCEngineKit library won't
      # be able to generate complete dSYM file which is required to symbolicate crash logs correctly
      # if the global/non-global symbols stripped here
      target_set_xcode_property(${target} COPY_PHASE_STRIP "NO" Release)
      target_set_xcode_property(${target} STRIP_INSTALLED_PRODUCT "NO" Release)
      target_set_xcode_property(${target} STRIP_STYLE "debugging" Release)
      target_set_xcode_property(${target} STRIP_SWIFT_SYMBOLS "NO" Release)
    endif()
    target_set_xcode_property(${target} CURRENT_PROJECT_VERSION "1.0.0")
    target_set_xcode_property(${target} LD_RUNPATH_SEARCH_PATHS "@executable_path/../Frameworks @loader_path/Frameworks")
    target_set_xcode_property(${target} LD_GENERATE_MAP_FILE "YES" Release)
    target_set_xcode_property(${target} LD_MAP_FILE_PATH "${CMAKE_BINARY_DIR}/$<CONFIG>/$(PRODUCT_NAME)-LinkMap-$(CURRENT_VARIANT)-$(CURRENT_ARCH).txt" Release)
    target_set_xcode_property(${target} GCC_GENERATE_DEBUGGING_SYMBOLS "YES")
    # Visibility
    target_set_xcode_property(${target} GCC_SYMBOLS_PRIVATE_EXTERN "YES")

    # Code Coverage
    if(RTC_ENABLE_COVERAGE)
      target_set_xcode_property(${target} GCC_GENERATE_TEST_COVERAGE_FILES "YES")
      target_set_xcode_property(${target} GCC_INSTRUMENT_PROGRAM_FLOW_ARCS "YES")
    endif()

    # Bitcode 
    if(RTC_ENABLE_BITCODE)
      target_set_xcode_property(${target} BITCODE_GENERATION_MODE "bitcode")
      target_set_xcode_property(${target} ENABLE_BITCODE "YES")
    else() 
      target_set_xcode_property(${target} ENABLE_BITCODE "NO")
    endif()

    # Arc
    if(RTC_ENABLE_ARC)
      target_set_xcode_property(${target} CLANG_ENABLE_OBJC_ARC "YES")
    else()
      target_set_xcode_property(${target} CLANG_ENABLE_OBJC_ARC "NO")
    endif()

    # LTO
    if(RTC_ENABLE_LTO)
      target_set_xcode_property(${target} CLANG_FLTO "YES" Release)
      target_set_xcode_property(${target} LLVM_LTO "YES" Release)
    else()
      target_set_xcode_property(${target} CLANG_FLTO "NO" Release)
    endif()

    # Exception
    if (RTC_CPP_EXCEPTION)
      target_set_xcode_property(${target} GCC_ENABLE_CPP_EXCEPTIONS "YES" Release)
    else()
      target_set_xcode_property(${target} GCC_ENABLE_CPP_EXCEPTIONS "NO" Release)
    endif()

    # RTTI
    if (RTC_CPP_RTTI)
      target_set_xcode_property(${target} GCC_ENABLE_CPP_RTTI "YES" Release)
    else()
      target_set_xcode_property(${target} GCC_ENABLE_CPP_RTTI "NO" Release)
    endif()

    # Code Sign
    if (ENABLE_CODESIGN)
      target_set_xcode_property(${target} CODE_SIGNING_REQUIRED "YES" Release)
    else()
      target_set_xcode_property(${target} CODE_SIGNING_REQUIRED "NO" Release)
    endif()

    # if (PLATFORM_IOS AND (RTC_IOS_PLATFORM STREQUAL "SIMULATOR") )
    #   # this link options is required for i386 to skip ld: illegal text-relocation to 'rtc_1pos_table' in openh264
    #   rtc_add_link_option(${target} "-read_only_relocs")
    #   rtc_add_link_option(${target} "suprpress")
    # endif()

    # if (PLATFORM_IOS AND (NOT ${CMAKE_VERSION} VERSION_LESS "3.11"))
    #   target_set_xcode_property(${target} IPHONEOS_DEPLOYMENT_TARGET "${RTC_IOS_DEPLOYMENT_TARGET}")
    # endif()
  endif()
endmacro()

# copy framework to app target
macro(target_copy_framework target framework)
  if(PLATFORM_APPLE)
    if(PLATFORM_IOS)
      # If framework is ios platform, then check Info.plist
      add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND /bin/bash ${PROJECT_CMAKE_ROOT}/scripts/install_framework.sh ${framework} false
      )
    else()
      # If framework is macos platform, don't check Info.plist
      add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND /bin/bash ${PROJECT_CMAKE_ROOT}/scripts/install_framework.sh ${framework} false
      )
    endif()
  endif()
endmacro(target_copy_framework)

