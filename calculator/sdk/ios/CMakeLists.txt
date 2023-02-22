# cmake -G"Xcode" -Bbuild -DTARGET_PLATFORM=ios -DPLATFORM=OS64COMBINED .

# add objc source
target_sources(calculator PRIVATE CalculatorApple.h CalculatorApple.mm)

# set default xcode properties
if(PLATFORM_APPLE)
  target_apply_xcode_default_config(calculator)
  if(GEN_FRAMEWORK)
    set_target_properties(
      calculator
      PROPERTIES FRAMEWORK TRUE
                 FRAMEWORK_VERSION A
                 MACOSX_FRAMEWORK_IDENTIFIER com.example.calculator
                 # MACOSX_FRAMEWORK_INFO_PLIST Info.plist
                 # "current version" in semantic format in Mach-O binary file
                 VERSION 1.0.0
                 # "compatibility version" in semantic format in Mach-O binary
                 # file
                 SOVERSION 1.0.0
                 # PUBLIC_HEADER CalculatorApple.h
    )
    target_set_xcode_property(calculator DEFINES_MODULE "YES")
    target_set_xcode_property(calculator PRODUCT_BUNDLE_IDENTIFIER
                              "com.example.calculator")

    # target_set_xcode_property( FRAMEWORK_VERSION 1.0.0)
    # target_set_xcode_property(calculator DEFINES_MODULE "YES")
    # target_set_xcode_property(calculator PRODUCT_BUNDLE_IDENTIFIER
    # "calculator") target_set_xcode_property(calculator INFOPLIST_FILE
    # ${PROJECT_ROOT}/calculator/sdk/ios/Info.plist)

    # MACOSX_PACKAGE_LOCATION关键字可以将文件复制到特定的路径中，在IOS framework中，
    # 就是<name>.framework/ set_property(SOURCE
    # ${CMAKE_CURRENT_SOURCE_DIR}/CalculatorApple.h PROPERTY
    # MACOSX_PACKAGE_LOCATION Headers/Calculator)
  endif()

endif(PLATFORM_APPLE)
