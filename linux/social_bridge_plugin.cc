#include "include/social_bridge/social_bridge_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#include <cstring>

#include "social_bridge_plugin_private.h"

#define SOCIAL_BRIDGE_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), social_bridge_plugin_get_type(), \
                              SocialBridgePlugin))

struct _SocialBridgePlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(SocialBridgePlugin, social_bridge_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void social_bridge_plugin_handle_method_call(
    SocialBridgePlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response =
      FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());

  fl_method_call_respond(method_call, response, nullptr);
}

static void social_bridge_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(social_bridge_plugin_parent_class)->dispose(object);
}

static void social_bridge_plugin_class_init(SocialBridgePluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = social_bridge_plugin_dispose;
}

static void social_bridge_plugin_init(SocialBridgePlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  SocialBridgePlugin* plugin = SOCIAL_BRIDGE_PLUGIN(user_data);
  social_bridge_plugin_handle_method_call(plugin, method_call);
}

void social_bridge_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  SocialBridgePlugin* plugin = SOCIAL_BRIDGE_PLUGIN(
      g_object_new(social_bridge_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "social_bridge",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
