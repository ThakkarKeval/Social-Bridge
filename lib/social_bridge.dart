import 'social_bridge_platform_interface.dart';
import 'src/models/social_auth_result.dart';

export 'src/models/social_auth_exception.dart';
export 'src/models/social_auth_result.dart';

class SocialBridge {
  const SocialBridge();

  Future<SocialAuthResult> signInWithGoogle({
    required String serverClientId,
    String? nonce,
    bool filterByAuthorizedAccounts = false,
  }) {
    return SocialBridgePlatform.instance.signInWithGoogle(
      serverClientId: serverClientId,
      nonce: nonce,
      filterByAuthorizedAccounts: filterByAuthorizedAccounts,
    );
  }

  Future<SocialAuthResult> signInWithApple({
    List<String> scopes = const ['email', 'name'],
  }) {
    return SocialBridgePlatform.instance.signInWithApple(
      scopes: scopes,
    );
  }

  Future<void> signOut() {
    return SocialBridgePlatform.instance.signOut();
  }
}
