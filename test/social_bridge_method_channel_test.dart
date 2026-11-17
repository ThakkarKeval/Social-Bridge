import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_bridge/social_bridge.dart';
import 'package:social_bridge/social_bridge_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelSocialBridge();
  const channel = MethodChannel('social_bridge');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'signInWithGoogle':
              final args = methodCall.arguments as Map;
              if (args['serverClientId'] == 'error-client-id') {
                throw PlatformException(
                  code: 'CREDENTIAL_ERROR',
                  message: 'Google Sign-In failed.',
                );
              }
              if (args['serverClientId'] == 'cancel-client-id') {
                throw PlatformException(
                  code: 'CANCELLED',
                  message: 'User cancelled Google Sign-In.',
                );
              }
              return {
                'provider': 'google',
                'idToken': 'mock-id-token',
                'email': 'test@gmail.com',
                'displayName': 'Test User',
                'userIdentifier': 'google-123',
              };
            case 'signInWithApple':
              return {
                'provider': 'apple',
                'idToken': 'mock-apple-id-token',
                'email': 'apple@example.com',
                'displayName': 'Apple User',
                'userIdentifier': 'apple-123',
              };
            case 'signOut':
              return null;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
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
