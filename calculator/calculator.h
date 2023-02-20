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
class EXPORT_CLASS Caclulator {
private:
    std::string _version = "1.0.0";
    static PluginManager* _pluginManager;

public:
    Caclulator();
    explicit Caclulator(const std::string &version);
    virtual ~Caclulator();

    void setVersion(std::string version);
    std::string getVersion() const;
    int add(int a, int b);
    int sub(int a, int b);
};
#endif //TEST_PLUGIN_CALCULATOR_H
