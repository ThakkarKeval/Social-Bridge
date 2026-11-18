// ignore_for_file: non_constant_identifier_names

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_bridge/social_bridge.dart';
import 'package:social_bridge/social_bridge_method_channel.dart';
import 'package:social_bridge/src/messages.g.dart';

class MockSocialBridgeHostApi implements SocialBridgeHostApi {
  @override
  BinaryMessenger? get pigeonVar_binaryMessenger => null;

  @override
  String get pigeonVar_messageChannelSuffix => '';

  @override
  Future<NativeSocialAuthResult> signInWithGoogle(
      GoogleSignInRequest request) async {
    if (request.serverClientId == 'error-client-id') {
      throw PlatformException(
        code: 'CREDENTIAL_ERROR',
        message: 'Google Sign-In failed.',
      );
    }
    if (request.serverClientId == 'cancel-client-id') {
      throw PlatformException(
        code: 'CANCELLED',
        message: 'User cancelled Google Sign-In.',
      );
    }
    return NativeSocialAuthResult(
      provider: 'google',
      idToken: 'mock-id-token',
      email: 'test@gmail.com',
      displayName: 'Test User',
      userIdentifier: 'google-123',
    );
  }

  @override
  Future<NativeSocialAuthResult> signInWithApple(
      AppleSignInRequest request) async {
    return NativeSocialAuthResult(
      provider: 'apple',
      idToken: 'mock-apple-id-token',
      email: 'apple@example.com',
      displayName: 'Apple User',
      userIdentifier: 'apple-123',
    );
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelSocialBridge platform;
  late MockSocialBridgeHostApi mockApi;

  setUp(() {
    mockApi = MockSocialBridgeHostApi();
    platform = MethodChannelSocialBridge(hostApi: mockApi);
  });

  test('signInWithGoogle success', () async {
    final result = await platform.signInWithGoogle(
      serverClientId: 'valid-client-id',
    );
    expect(result.provider, 'google');
    expect(result.idToken, 'mock-id-token');
    expect(result.email, 'test@gmail.com');
  });

  test('signInWithGoogle throws SocialAuthCancelledException on CANCELLED', () async {
    expect(
      () => platform.signInWithGoogle(serverClientId: 'cancel-client-id'),
      throwsA(isA<SocialAuthCancelledException>()),
    );
  });

  test('signInWithGoogle throws SocialAuthException on error', () async {
    expect(
      () => platform.signInWithGoogle(serverClientId: 'error-client-id'),
      throwsA(isA<SocialAuthException>()),
    );
  });

  test('signInWithApple success', () async {
    final result = await platform.signInWithApple();
    expect(result.provider, 'apple');
    expect(result.idToken, 'mock-apple-id-token');
    expect(result.email, 'apple@example.com');
  });

  test('signOut success', () async {
    expect(platform.signOut(), completes);
  });
}
