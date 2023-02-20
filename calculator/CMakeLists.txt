if(NOT BUILD_SDK)
   return()
endif ()

# main sdk
add_library(calculator SHARED calculator.cpp dir.cpp DLibrary.cpp plugin_manager.cpp)
target_include_directories(calculator PUBLIC ${PROJECT_ROOT}/calculator)
# set_target_properties(calculator PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
# libadd plugin
add_library(add SHARED libadd.h libadd.cpp)
# libsub plugin
add_library(sub SHARED libsub.h libsub.cpp)


message(STATUS "CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
message(STATUS "CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
