//
// Created by mojucheng on 2023/2/20.
//

#include "DLibrary.h"
#include <cstdio>

DLibrary* DLibrary::load(const std::string &path) {
    if ( path.empty() ){
        fprintf(stderr, "Failed to load library: Empty path\n");
        return NULL;
    }
    void* handle = NULL;
    // load library - OS dependent operation
#ifdef WIN32
    handle = ::LoadLibraryA(path.c_str());
        if (!handle){
            fprintf(stderr, "Failed to load library \"%s\".\n", path.c_str());
            return NULL;
        }
#else
    handle = ::dlopen(path.c_str(), RTLD_NOW);
    if (!handle){
        const char* errorString = ::dlerror();
        fprintf(stderr, "Failed to load library \"%s\".", path.c_str());
        if(errorString) fprintf(stderr, " OS returned error: \"%s\".", errorString);
        fprintf(stderr, "\n");
        return NULL;
    }
#endif
    // return a DLibrary with the DLL handle
    return new DLibrary(handle);
}

DLibrary::~DLibrary(){
    if (handle){
    #ifdef WIN32
        ::FreeLibrary( (HMODULE)handle );
    #else
        ::dlclose(handle);
    #endif
    }
}

void* DLibrary::getSymbol(const std::string& symbol){
    if (!handle){
        fprintf(stderr, "Cannot inspect library symbols, library isn't loaded.\n");
        return NULL;
    }
    void* res;
#ifdef WIN32
    res = (void*)(::GetProcAddress((HMODULE)handle, symbol.c_str()));
#else
    res = (void*)(::dlsym(handle, symbol.c_str()));
#endif
    if (!res){
        fprintf(stderr, "Library symbol \"%s\" not found.\n", symbol.c_str());
        return NULL;
    }
    return res;
}
DLibrary::DLibrary(void* handle):
        handle(handle)
{
    // Nothing to do
}
