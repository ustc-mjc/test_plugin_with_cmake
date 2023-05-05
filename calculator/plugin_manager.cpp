//
// Created by mojucheng on 2023/2/20.
//

#include "plugin_manager.h"
#include "dir.h"
#include "lib_export_common.h"
#include <list>

PluginManager::PluginManager() {}

PluginManager::~PluginManager() { unloadAll(); }

bool PluginManager::load(const std::string &lib_name) {
  // std::string plugName = getPluginName(path);
  // std::string realPath = resolvePathExtension(path);
  // DLibrary* lib = DLibrary::load(realPath);
  std::string plugName = lib_name;
  std::string full_name;
#if PLATFORM_MAC || PLATFORM_IOS
  std::string frwk(".framework/");
  full_name = lib_name + frwk + lib_name;
//   std::string dylib(lib_name);
//   lib_name = "lib" + dylib + ".dylib";
#elif PLATFORM_WINDOWS
  full_name = lib_name + ".dll";
#else
  full_name = "lib" + lib_name + ".so";
#endif
  DLibrary *lib = DLibrary::load(full_name);
  if (!lib)
    return false;
  libraries[plugName] = lib;
  return true;
}

bool PluginManager::load(const std::string &folder,
                         const std::string &pluginName) {
  if (folder.empty())
    return load(pluginName);
  else if (folder[folder.size() - 1] == '/' ||
           folder[folder.size() - 1] == '\\')
    return load(folder + pluginName);
  return load(folder + '/' + pluginName);
}

int PluginManager::loadFromFolder(const std::string &folder, bool recursive) {
  std::list<std::string> files;
  dir::listFiles(files, folder, LIB_EXTENSION, recursive);
  // try to load every library
  int res = 0;
  std::list<std::string>::const_iterator it;
  for (it = files.begin(); it != files.end(); ++it) {
    if (load(*it))
      ++res;
  }
  return res;
}

std::string PluginManager::getPluginName(const std::string &path) {
  size_t lastDash = path.find_last_of("/\\");
  size_t lastDot = path.find_last_of('.');
  if (lastDash == std::string::npos)
    lastDash = 0;
  else
    ++lastDash;
  if (lastDot < lastDash || lastDot == std::string::npos) {
    // path without extension
    lastDot = path.length();
  }
  return path.substr(lastDash, lastDot - lastDash);
}

std::string PluginManager::resolvePathExtension(const std::string &path) {
  size_t lastDash = path.find_last_of("/\\");
  size_t lastDot = path.find_last_of('.');
  if (lastDash == std::string::npos)
    lastDash = 0;
  else
    ++lastDash;
  if (lastDot < lastDash || lastDot == std::string::npos) {
    // path without extension, add it
    return path + "." + LIB_EXTENSION;
  }
  return path;
}

bool PluginManager::unload(const std::string &pluginName) {
  std::string plugName = getPluginName(pluginName);
  LibMap::iterator it = libraries.find(plugName);
  if (it != libraries.end()) {
    delete it->second;
    libraries.erase(it);
    return true;
  }
  return false;
}

void PluginManager::unloadAll() {

  LibMap::iterator it;
  for (it = libraries.begin(); it != libraries.end(); ++it) {
    delete it->second;
  }
  libraries.clear();
}

bool PluginManager::isLoaded(const std::string &pluginName) const {
  return libraries.find(getPluginName(pluginName)) != libraries.end();
}

DLibrary *PluginManager::getDlibrary(const std::string &pluginName) {
  auto iter = libraries.find(pluginName);
  if (iter != libraries.end()) {
    return iter->second;
  }
  return nullptr;
}
