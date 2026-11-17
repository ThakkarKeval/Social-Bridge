import 'social_bridge_platform_interface.dart';
import 'src/models/social_auth_result.dart';

export 'src/models/social_auth_exception.dart';
export 'src/models/social_auth_result.dart';

/// Main entry point for social authentication with Google and Apple.
class SocialBridge {
  /// Constructs a [SocialBridge] instance.
  const SocialBridge();

  /// Initiates Google Sign-In using modern Android Credential Manager on Android.
  ///
  /// [serverClientId] is the OAuth 2.0 Web Client ID from the Google Cloud Console.
  /// [nonce] is an optional cryptographic nonce for replay protection.
  /// [filterByAuthorizedAccounts] filters by accounts previously authorized for the app.
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

  /// Initiates Apple Sign-In using Firebase Auth OAuthProvider on Android
  /// and native `AuthenticationServices` on iOS.
  ///
  /// [scopes] specifies the user profile information requested (defaults to `['email', 'name']`).
  Future<SocialAuthResult> signInWithApple({
    List<String> scopes = const ['email', 'name'],
  }) {
    return SocialBridgePlatform.instance.signInWithApple(
      scopes: scopes,
    );
  }

  /// Signs out of all active social authentication sessions and clears cached credentials.
  Future<void> signOut() {
    return SocialBridgePlatform.instance.signOut();
  }
}
