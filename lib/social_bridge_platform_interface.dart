import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'social_bridge_method_channel.dart';
import 'src/models/social_auth_result.dart';

abstract class SocialBridgePlatform extends PlatformInterface {
  SocialBridgePlatform() : super(token: _token);

  static final Object _token = Object();

  static SocialBridgePlatform _instance = MethodChannelSocialBridge();

  static SocialBridgePlatform get instance => _instance;

  static set instance(SocialBridgePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<SocialAuthResult> signInWithGoogle({
    required String serverClientId,
    String? nonce,
    bool filterByAuthorizedAccounts = false,
  }) {
    throw UnimplementedError('signInWithGoogle() has not been implemented.');
  }

  Future<SocialAuthResult> signInWithApple({
    List<String>? scopes,
  }) {
    throw UnimplementedError('signInWithApple() has not been implemented.');
  }

  Future<void> signOut() {
    throw UnimplementedError('signOut() has not been implemented.');
  }
}
