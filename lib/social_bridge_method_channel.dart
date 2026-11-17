import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'social_bridge_platform_interface.dart';
import 'src/models/social_auth_exception.dart';
import 'src/models/social_auth_result.dart';

/// An implementation of [SocialBridgePlatform] that uses method channels.
class MethodChannelSocialBridge extends SocialBridgePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('social_bridge');

  @override
  Future<SocialAuthResult> signInWithGoogle({
    required String serverClientId,
    String? nonce,
    bool filterByAuthorizedAccounts = false,
  }) async {
    try {
      final response = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'signInWithGoogle',
        {
          'serverClientId': serverClientId,
          'nonce': nonce,
          'filterByAuthorizedAccounts': filterByAuthorizedAccounts,
        },
      );
      if (response == null) {
        throw const SocialAuthException(
          code: 'EMPTY_RESPONSE',
          message: 'Received empty response from Google Sign-In.',
        );
      }
      return SocialAuthResult.fromMap(response);
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
      final response = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'signInWithApple',
        {
          'scopes': scopes,
        },
      );
      if (response == null) {
        throw const SocialAuthException(
          code: 'EMPTY_RESPONSE',
          message: 'Received empty response from Apple Sign-In.',
        );
      }
      return SocialAuthResult.fromMap(response);
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
      await methodChannel.invokeMethod<void>('signOut');
    } on PlatformException catch (e) {
      throw SocialAuthException(
        code: e.code,
        message: e.message ?? 'Sign out failed.',
        details: e.details,
      );
    }
  }
}
