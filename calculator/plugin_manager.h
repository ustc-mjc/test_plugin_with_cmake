//
// Created by mojucheng on 2023/2/20.
//

#ifndef TEST_PLUGIN_PLUGIN_MANAGER_H
#define TEST_PLUGIN_PLUGIN_MANAGER_H
#include <string>
#include <map>
#include "DLibrary.h"
class PluginManager {
private:

public:
    PluginManager();
    bool load(std::string& path);

    bool load(const std::string& folder, const std::string& pluginName);

    int loadFromFolder(const std::string& folder, bool recursive = false);

    bool unload(const std::string& pluginName);

    void unloadAll();

    DLibrary* getDlibrary(const std::string& pluginName);

    bool isLoaded(const std::string& pluginName) const;
    virtual ~PluginManager();

private:
    static std::string getPluginName(const std::string& path);
    static std::string resolvePathExtension(const std::string& path);

    typedef std::map<std::string,DLibrary*> LibMap;
    LibMap libraries;
};


#endif //TEST_PLUGIN_PLUGIN_MANAGER_H
