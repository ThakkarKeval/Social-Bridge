import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'social_bridge_method_channel.dart';

abstract class SocialBridgePlatform extends PlatformInterface {
  /// Constructs a SocialBridgePlatform.
  SocialBridgePlatform() : super(token: _token);

  static final Object _token = Object();

  static SocialBridgePlatform _instance = MethodChannelSocialBridge();

  /// The default instance of [SocialBridgePlatform] to use.
  ///
  /// Defaults to [MethodChannelSocialBridge].
  static SocialBridgePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SocialBridgePlatform] when
  /// they register themselves.
  static set instance(SocialBridgePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
