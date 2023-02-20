//
// Created by mojucheng on 2023/2/17.
//
#ifdef WIN32
#pragma warning( disable : 4716)
#endif

#include "calculator.h"

EXPORT_API Caclulator::Caclulator() {}
EXPORT_API Caclulator::Caclulator(const std::string &version) : _version(version) {}

EXPORT_API Caclulator::~Caclulator() {

}
EXPORT_API void Caclulator::setVersion(std::string version) {
    _version = version;
}

EXPORT_API std::string Caclulator::getVersion() const {
    return _version;
}

PluginManager* Caclulator::_pluginManager = new PluginManager();

EXPORT_API int Caclulator::add(int a, int b) {
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

EXPORT_API int Caclulator::sub(int a, int b) {
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

