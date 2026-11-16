#include "include/social_bridge/social_bridge_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "social_bridge_plugin.h"

void SocialBridgePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  social_bridge::SocialBridgePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
