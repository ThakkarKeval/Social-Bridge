#include "social_bridge_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace social_bridge {

// static
void SocialBridgePlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto plugin = std::make_unique<SocialBridgePlugin>();

  SocialBridgeHostApi::SetUp(registrar->messenger(), plugin.get());

  registrar->AddPlugin(std::move(plugin));
}

SocialBridgePlugin::SocialBridgePlugin() {}

SocialBridgePlugin::~SocialBridgePlugin() {}

void SocialBridgePlugin::SignInWithGoogle(
    const GoogleSignInRequest& request,
    std::function<void(ErrorOr<NativeSocialAuthResult> reply)> result) {
  result(FlutterError("UNSUPPORTED_PLATFORM", "Google Sign-In is not supported on Windows."));
}

void SocialBridgePlugin::SignInWithApple(
    const AppleSignInRequest& request,
    std::function<void(ErrorOr<NativeSocialAuthResult> reply)> result) {
  result(FlutterError("UNSUPPORTED_PLATFORM", "Apple Sign-In is not supported on Windows."));
}

void SocialBridgePlugin::SignOut(
    std::function<void(std::optional<FlutterError> reply)> result) {
  result(std::nullopt);
}

}  // namespace social_bridge
