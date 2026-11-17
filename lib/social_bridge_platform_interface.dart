import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'social_bridge_method_channel.dart';
import 'src/models/social_auth_result.dart';

/// The common platform interface contract for `social_bridge` implementations.
abstract class SocialBridgePlatform extends PlatformInterface {
  /// Constructs a [SocialBridgePlatform].
  SocialBridgePlatform() : super(token: _token);

  static final Object _token = Object();

  static SocialBridgePlatform _instance = MethodChannelSocialBridge();

  /// The default instance of [SocialBridgePlatform] to use.
  static SocialBridgePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SocialBridgePlatform] when
  /// they register themselves.
  static set instance(SocialBridgePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Initiates Google Sign-In on the platform.
  Future<SocialAuthResult> signInWithGoogle({
    required String serverClientId,
    String? nonce,
    bool filterByAuthorizedAccounts = false,
  }) {
    throw UnimplementedError('signInWithGoogle() has not been implemented.');
  }

  /// Initiates Apple Sign-In on the platform.
  Future<SocialAuthResult> signInWithApple({
    List<String>? scopes,
  }) {
    throw UnimplementedError('signInWithApple() has not been implemented.');
  }

  /// Signs out of all active social authentication sessions on the platform.
  Future<void> signOut() {
    throw UnimplementedError('signOut() has not been implemented.');
  }
}
