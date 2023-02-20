//
// Created by mojucheng on 2023/2/20.
//

#ifndef TEST_PLUGIN_LIB_EXPORT_COMMON_H
#define TEST_PLUGIN_LIB_EXPORT_COMMON_H

////////////////////////////////////////////////////////////
// Identify the operating system
////////////////////////////////////////////////////////////
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32__)

// Windows
    #define SYS_WINDOWS
    #ifndef WIN32_LEAN_AND_MEAN
        #define WIN32_LEAN_AND_MEAN
    #endif
    #ifndef NOMINMAX
        #define NOMINMAX
    #endif

#elif defined(linux) || defined(__linux)

// Linux
    #define SYS_LINUX

#elif defined(__APPLE__) || defined(MACOSX) || defined(macintosh) || defined(Macintosh)

// MacOS
#define SYS_MACOS

#elif defined(__FreeBSD__) || defined(__FreeBSD_kernel__)

// FreeBSD
    #define SYS_FREEBSD

#else

    // Unsupported system
    #error This operating system is not supported by this library

#endif



////////////////////////////////////////////////////////////
// Define library file extension based on OS
////////////////////////////////////////////////////////////
#ifdef SYS_WINDOWS
#define LIB_EXTENSION "dll"
#elif defined(SYS_MACOS)
#define LIB_EXTENSION "dylib"
#elif defined(SYS_LINUX) || defined(SYS_FREEBSD)
#define IB_EXTENSION "so"
#else
   // unknown library file type
    #error Unknown library file extension for this operating system
#endif


#if defined WIN32 || defined __CYGWIN__
#ifdef __cplusplus
#define DLL_EXPORT_C_DECL extern "C" __declspec(dllexport)
#define DLL_IMPORT_C_DECL extern "C" __declspec(dllimport)
#define DLL_EXPORT_DECL extern __declspec(dllexport)
#define DLL_IMPORT_DECL extern __declspec(dllimport)
#define DLL_EXPORT_CLASS_DECL __declspec(dllexport)
#define DLL_IMPORT_CLASS_DECL __declspec(dllimport)
#else
#define DLL_EXPORT_DECL __declspec(dllexport)
#define DLL_IMPORT_DECL __declspec(dllimport)
#endif
#else
#ifdef __cplusplus
#define DLL_EXPORT_C_DECL __attribute__ ((visibility ("default"))) extern "C"
#define DLL_IMPORT_C_DECL __attribute__ ((visibility ("default"))) extern "C"
#define DLL_EXPORT_DECL __attribute__ ((visibility ("default"))) extern
#define DLL_IMPORT_DECL __attribute__ ((visibility ("default"))) extern
#define DLL_EXPORT_CLASS_DECL
#define DLL_IMPORT_CLASS_DECL
#else
#define DLL_EXPORT_DECL extern
#define DLL_IMPORT_DECL extern
#endif
#endif

#endif //TEST_PLUGIN_LIB_EXPORT_COMMON_H
