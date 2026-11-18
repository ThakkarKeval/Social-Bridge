#include "include/social_bridge/social_bridge_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

#include <cstring>

#include "social_bridge_plugin_private.h"
#include "messages.g.h"

#define SOCIAL_BRIDGE_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), social_bridge_plugin_get_type(), \
                              SocialBridgePlugin))

struct _SocialBridgePlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(SocialBridgePlugin, social_bridge_plugin, g_object_get_type())

static void sign_in_with_google(
    SocialBridgeGoogleSignInRequest* request,
    SocialBridgeSocialBridgeHostApiResponseHandle* response_handle,
    gpointer user_data) {
  social_bridge_social_bridge_host_api_respond_error_sign_in_with_google(
      response_handle, "UNSUPPORTED_PLATFORM", "Google Sign-In is not supported on Linux.", nullptr);
}

static void sign_in_with_apple(
    SocialBridgeAppleSignInRequest* request,
    SocialBridgeSocialBridgeHostApiResponseHandle* response_handle,
    gpointer user_data) {
  social_bridge_social_bridge_host_api_respond_error_sign_in_with_apple(
      response_handle, "UNSUPPORTED_PLATFORM", "Apple Sign-In is not supported on Linux.", nullptr);
}

static void sign_out(
    SocialBridgeSocialBridgeHostApiResponseHandle* response_handle,
    gpointer user_data) {
  social_bridge_social_bridge_host_api_respond_sign_out(response_handle);
}

static const SocialBridgeSocialBridgeHostApiVTable host_api_vtable = {
  .sign_in_with_google = sign_in_with_google,
  .sign_in_with_apple = sign_in_with_apple,
  .sign_out = sign_out,
};

static void social_bridge_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(social_bridge_plugin_parent_class)->dispose(object);
}

static void social_bridge_plugin_class_init(SocialBridgePluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = social_bridge_plugin_dispose;
}

static void social_bridge_plugin_init(SocialBridgePlugin* self) {}

void social_bridge_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  SocialBridgePlugin* plugin = SOCIAL_BRIDGE_PLUGIN(
      g_object_new(social_bridge_plugin_get_type(), nullptr));

  FlBinaryMessenger* messenger = fl_plugin_registrar_get_messenger(registrar);
  social_bridge_social_bridge_host_api_set_method_handlers(
      messenger, nullptr, &host_api_vtable, g_object_ref(plugin), g_object_unref);

  g_object_unref(plugin);
}
