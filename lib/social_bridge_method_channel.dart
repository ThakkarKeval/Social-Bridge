import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'social_bridge_platform_interface.dart';
import 'src/messages.g.dart';
import 'src/models/social_auth_exception.dart';
import 'src/models/social_auth_result.dart';

/// An implementation of [SocialBridgePlatform] that uses Pigeon.
class MethodChannelSocialBridge extends SocialBridgePlatform {
  /// Constructs a [MethodChannelSocialBridge].
  MethodChannelSocialBridge({SocialBridgeHostApi? hostApi})
      : _hostApi = hostApi ?? SocialBridgeHostApi();

  final SocialBridgeHostApi _hostApi;

  /// The Pigeon host API instance.
  @visibleForTesting
  SocialBridgeHostApi get hostApi => _hostApi;

  @override
  Future<SocialAuthResult> signInWithGoogle({
    required String serverClientId,
    String? nonce,
    bool filterByAuthorizedAccounts = false,
  }) async {
    try {
      final response = await _hostApi.signInWithGoogle(
        GoogleSignInRequest(
          serverClientId: serverClientId,
          nonce: nonce,
          filterByAuthorizedAccounts: filterByAuthorizedAccounts,
        ),
      );
      return _toSocialAuthResult(response);
    } on PlatformException catch (e) {
      if (e.code == 'CANCELLED') {
        throw SocialAuthCancelledException(details: e.details);
      }
      throw SocialAuthException(
        code: e.code,
        message: e.message ?? 'Google Sign-In failed.',
        details: e.details,
      );
    }
  }

  @override
  Future<SocialAuthResult> signInWithApple({
    List<String>? scopes,
  }) async {
    try {
      final response = await _hostApi.signInWithApple(
        AppleSignInRequest(scopes: scopes),
      );
      return _toSocialAuthResult(response);
    } on PlatformException catch (e) {
      if (e.code == 'CANCELLED') {
        throw SocialAuthCancelledException(details: e.details);
      }
      throw SocialAuthException(
        code: e.code,
        message: e.message ?? 'Apple Sign-In failed.',
        details: e.details,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _hostApi.signOut();
    } on PlatformException catch (e) {
      throw SocialAuthException(
        code: e.code,
        message: e.message ?? 'Sign out failed.',
        details: e.details,
      );
    }
  }

  SocialAuthResult _toSocialAuthResult(NativeSocialAuthResult nativeResult) {
    return SocialAuthResult(
      provider: nativeResult.provider,
      idToken: nativeResult.idToken,
      accessToken: nativeResult.accessToken,
      email: nativeResult.email,
      displayName: nativeResult.displayName,
      userIdentifier: nativeResult.userIdentifier,
      photoUrl: nativeResult.photoUrl,
      rawData: <String, dynamic>{
        'provider': nativeResult.provider,
        'idToken': nativeResult.idToken,
        'accessToken': nativeResult.accessToken,
        'email': nativeResult.email,
        'displayName': nativeResult.displayName,
        'userIdentifier': nativeResult.userIdentifier,
        'photoUrl': nativeResult.photoUrl,
      },
    );
  }
}
