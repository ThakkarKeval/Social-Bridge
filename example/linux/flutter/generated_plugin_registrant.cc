//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <social_bridge/social_bridge_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) social_bridge_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SocialBridgePlugin");
  social_bridge_plugin_register_with_registrar(social_bridge_registrar);
}
