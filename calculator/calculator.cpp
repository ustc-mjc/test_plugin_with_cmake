//
// Created by mojucheng on 2023/2/17.
//

#include "calculator.h"

// windows not need define extern
#ifdef _WIN32
    #define EXPORT_API
#endif

EXPORT_API Calculator::Calculator() {}

EXPORT_API Calculator::~Calculator() {

}
EXPORT_API void Calculator::setVersion(std::string version) {
    _version = version;
}

EXPORT_API std::string Calculator::getVersion() {
    return _version;
}
std::string Calculator::_version = "1.0.0";
PluginManager* Calculator::_pluginManager = new PluginManager();

EXPORT_API int Calculator::add(int a, int b) {
    typedef int(*padd)(int ,int);
    std::string pluginName = "libadd";
    bool status =  _pluginManager->load(pluginName);
    if (!status) {
        std::cout << "load libadd lib failed!" << std::endl;
    } else {
        std::cout << "load libadd lib success!" << std::endl;
    }
    DLibrary* plugin =  _pluginManager->getDlibrary(pluginName);
    padd plugin_add = reinterpret_cast<padd>(plugin->getSymbol("add"));
    return plugin_add(a, b);
}

EXPORT_API int Calculator::sub(int a, int b) {
    typedef int(*psub)(int ,int);
    std::string pluginName = "libsub";
    bool status = _pluginManager->load(pluginName);
    if (!status) {
        std::cout << "load libsub lib failed!" << std::endl;
    } else {
        std::cout << "load libsub lib success!" << std::endl;
    }
    DLibrary* plugin =  _pluginManager->getDlibrary(pluginName);
    psub plugin_sub = reinterpret_cast<psub>(plugin->getSymbol("sub"));
    return plugin_sub(a, b);
}

