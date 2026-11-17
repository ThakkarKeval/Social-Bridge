import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'social_bridge_platform_interface.dart';

/// A web implementation of the SocialBridgePlatform of the SocialBridge plugin.
class SocialBridgeWeb extends SocialBridgePlatform {
  /// Constructs a [SocialBridgeWeb].
  SocialBridgeWeb();

  /// Registers this class as the default instance of [SocialBridgePlatform].
  static void registerWith(Registrar registrar) {
    SocialBridgePlatform.instance = SocialBridgeWeb();
  }
}
