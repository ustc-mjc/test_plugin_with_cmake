//
// Created by mojucheng on 2023/2/17.
//

#ifndef TEST_PLUGIN_CALCULATOR_H
#define TEST_PLUGIN_CALCULATOR_H

#define SOME_EXPORTS
#include "lib_export_defines.h"
#include <string>
#include <iostream>
#include "plugin_manager.h"
class EXPORT_CLASS Calculator {
private:
    static std::string _version;
    static PluginManager* _pluginManager;

public:
    Calculator();
    virtual ~Calculator();

    static void setVersion(std::string version);
    static std::string getVersion();
    int add(int a, int b);
    int sub(int a, int b);
};
#endif //TEST_PLUGIN_CALCULATOR_H
