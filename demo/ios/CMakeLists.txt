set(IOS_DEMO_TARGET ios_app)
set(DEMO_ROOT "${CMAKE_CURRENT_LIST_DIR}")
file(GLOB DEMO_SOURCES "${DEMO_ROOT}/*.h" "${DEMO_ROOT}/*.m")
file(GLOB_RECURSE DEMO_STORYBOARD "${DEMO_ROOT}/*.storyboard")
list(APPEND DEMO_RESOURCES ${DEMO_STORYBOARD})

# find xcassets
execute_process(
  COMMAND find ${DEMO_ROOT} -name "*.xcassets" -d
  OUTPUT_VARIABLE DEMO_XCASSETS_ITEMS
  OUTPUT_STRIP_TRAILING_WHITESPACE)
if(NOT "x${DEMO_XCASSETS_ITEMS}" STREQUAL "x")
  string(REPLACE "\n" ";" DEMO_XCASSETS "${WATCHCAT_XCASSETS_ITEMS}")
  list(APPEND DEMO_RESOURCES ${WATCHCAT_XCASSETS})
endif()

list(APPEND DEMO_SOURCES ${DEMO_RESOURCES})
add_executable(${IOS_DEMO_TARGET} MACOSX_BUNDLE ${DEMO_SOURCES})
set_target_properties(${IOS_DEMO_TARGET} PROPERTIES RESOURCE
                                                    "${DEMO_RESOURCES}")

target_set_xcode_property(${IOS_DEMO_TARGET} MARKETING_VERSION "1.0.0")
target_set_xcode_property(${IOS_DEMO_TARGET} CURRENT_PROJECT_VERSION "1.0.0")
target_set_xcode_property(${IOS_DEMO_TARGET} PRODUCT_BUNDLE_IDENTIFIER
                          "com.example.test.ios_app")

# if(DEFINED CODE_SIGN_IDENTITY) target_set_xcode_property(${IOS_DEMO_TARGET}
# CODE_SIGN_IDENTITY "${CODE_SIGN_IDENTITY}" Release)
# target_set_xcode_property(${IOS_DEMO_TARGET} CODE_SIGN_IDENTITY "Apple
# Development: wei xie (5B2GEB8CHB)" Debug) else()
# target_set_xcode_property(${IOS_DEMO_TARGET} CODE_SIGN_IDENTITY "Apple
# Development: wei xie (5B2GEB8CHB)" Debug) target_set_xcode_property(
# ${IOS_DEMO_TARGET} CODE_SIGN_IDENTITY "iPhone Distribution: Beijing Bytedance
# Technology Co., Ltd" Release) endif()

# target_set_xcode_property(${IOS_DEMO_TARGET} CODE_SIGN_STYLE "Manual")

# if(DEFINED DEVELOPMENT_TEAM) target_set_xcode_property(${IOS_DEMO_TARGET}
# DEVELOPMENT_TEAM "${DEVELOPMENT_TEAM}" Release) else()
# target_set_xcode_property(${IOS_DEMO_TARGET} DEVELOPMENT_TEAM "FY6D8MZCZ5"
# Debug) target_set_xcode_property(${IOS_DEMO_TARGET} DEVELOPMENT_TEAM
# "XXHND5J98K" Release) endif()

# if(DEFINED PROVISIONING_PROFILE_SPECIFIER)
# target_set_xcode_property(${IOS_DEMO_TARGET} PROVISIONING_PROFILE_SPECIFIER
# "${PROVISIONING_PROFILE_SPECIFIER}" Release) else()
# target_set_xcode_property(${IOS_DEMO_TARGET} PROVISIONING_PROFILE_SPECIFIER
# "ByteDanceWatchCat" Debug) target_set_xcode_property(${IOS_DEMO_TARGET}
# PROVISIONING_PROFILE_SPECIFIER "ByteDanceRtcInHouseDist" Release) endif()

target_set_xcode_property(${IOS_DEMO_TARGET} ASSETCATALOG_COMPILER_APPICON_NAME
                          "AppIcon" All)
target_set_xcode_property(${IOS_DEMO_TARGET} ENABLE_STRICT_OBJC_MSGSEND "YES"
                          All)
target_set_xcode_property(${IOS_DEMO_TARGET} INFOPLIST_FILE
                          "${DEMO_ROOT}/Info.plist" All)
target_set_xcode_property(${IOS_DEMO_TARGET} LIBRARY_SEARCH_PATHS
                          "$(inherited)" All)
target_set_xcode_property(
  ${IOS_DEMO_TARGET} LD_RUNPATH_SEARCH_PATHS
  "$(inherited) @executable_path/../Frameworks @loader_path/Frameworks" All)
target_set_xcode_property(${IOS_DEMO_TARGET} SKIP_INSTALL "NO" Release)
target_set_xcode_property(${IOS_DEMO_TARGET} INSTALL_PATH "Release-iphoneos"
                          Release)
target_link_libraries(
  ${IOS_DEMO_TARGET} PRIVATE "-framework Foundation" "-framework CoreVideo"
                             "-framework Security" "-framework UIKit")
# add_custom_target( iosarchive COMMAND ${CMAKE_COMMAND} -E env
# DEVELOPER_DIR=${RTC_XCODE_DEVELOP_DIR} xcodebuild -workspace
# ${PROJECT_NAME}.xcworkspace -scheme ${IOS_DEMO_TARGET} -arch arm64
# -configuration $<CONFIG> -archivePath
# ${CMAKE_BINARY_DIR}/$<CONFIG>/1.0.0.xcarchive -derivedDataPath build_ci
# archive WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
# configure_file(${DEMO_ROOT}/exportPlist.plist.cmake
# ${CMAKE_BINARY_DIR}/exportPlist.plist)

# add_custom_target( iosexport COMMAND ${CMAKE_COMMAND} -E env
# DEVELOPER_DIR=${RTC_XCODE_DEVELOP_DIR} xcodebuild -exportArchive -archivePath
# ${CMAKE_BINARY_DIR}/$<CONFIG>/${RTC_SDK_VERSION_DEFINED}.xcarchive -exportPath
# ./ -exportOptionsPlist './exportPlist.plist' WORKING_DIRECTORY
# ${CMAKE_BINARY_DIR})

# add_dependencies(iosexport iosarchive)
