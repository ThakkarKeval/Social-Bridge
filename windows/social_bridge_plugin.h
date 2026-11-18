#ifndef FLUTTER_PLUGIN_SOCIAL_BRIDGE_PLUGIN_H_
#define FLUTTER_PLUGIN_SOCIAL_BRIDGE_PLUGIN_H_

#include <flutter/plugin_registrar_windows.h>
#include <memory>

#include "messages.g.h"

namespace social_bridge {

class SocialBridgePlugin : public flutter::Plugin, public SocialBridgeHostApi {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SocialBridgePlugin();

  virtual ~SocialBridgePlugin();

  // Disallow copy and assign.
  SocialBridgePlugin(const SocialBridgePlugin&) = delete;
  SocialBridgePlugin& operator=(const SocialBridgePlugin&) = delete;

  // SocialBridgeHostApi implementation:
  void SignInWithGoogle(
      const GoogleSignInRequest& request,
      std::function<void(ErrorOr<NativeSocialAuthResult> reply)> result) override;
  void SignInWithApple(
      const AppleSignInRequest& request,
      std::function<void(ErrorOr<NativeSocialAuthResult> reply)> result) override;
  void SignOut(
      std::function<void(std::optional<FlutterError> reply)> result) override;
};

}  // namespace social_bridge

#endif  // FLUTTER_PLUGIN_SOCIAL_BRIDGE_PLUGIN_H_
