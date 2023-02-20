//
// Created by mojucheng on 2023/2/20.
//

#ifndef TEST_PLUGIN_DLIBRARY_H
#define TEST_PLUGIN_DLIBRARY_H
#include <string>
#ifdef WIN32
    #include <Windows.h>
#else
    #include <dlfcn.h>
#endif

class DLibrary {
public:
    static DLibrary* load(const std::string& path);
    ~DLibrary();
    void* getSymbol(const std::string& symbol);
    DLibrary();
    DLibrary(void* handle);

private:
    void* handle;
};


#endif //TEST_PLUGIN_DLIBRARY_H
