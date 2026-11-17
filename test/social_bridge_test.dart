import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:social_bridge/social_bridge.dart';
import 'package:social_bridge/social_bridge_method_channel.dart';
import 'package:social_bridge/social_bridge_platform_interface.dart';

class MockSocialBridgePlatform
    with MockPlatformInterfaceMixin
    implements SocialBridgePlatform {
  @override
  Future<SocialAuthResult> signInWithGoogle({
    required String serverClientId,
    String? nonce,
    bool filterByAuthorizedAccounts = false,
  }) async {
    return const SocialAuthResult(
      provider: 'google',
      idToken: 'mock-google-id-token',
      email: 'user@example.com',
      displayName: 'Google User',
    );
  }

  @override
  Future<SocialAuthResult> signInWithApple({
    List<String>? scopes,
  }) async {
    return const SocialAuthResult(
      provider: 'apple',
      idToken: 'mock-apple-id-token',
      email: 'user@example.com',
      displayName: 'Apple User',
    );
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  final SocialBridgePlatform initialPlatform = SocialBridgePlatform.instance;

  test('$MethodChannelSocialBridge is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSocialBridge>());
  });

  group('SocialBridge', () {
    late SocialBridge plugin;
    late MockSocialBridgePlatform mockPlatform;

    setUp(() {
      plugin = const SocialBridge();
      mockPlatform = MockSocialBridgePlatform();
      SocialBridgePlatform.instance = mockPlatform;
    });

    test('signInWithGoogle delegates to platform instance', () async {
      final result = await plugin.signInWithGoogle(
        serverClientId: 'test-client-id',
      );
      expect(result.provider, 'google');
      expect(result.idToken, 'mock-google-id-token');
      expect(result.email, 'user@example.com');
    });

    test('signInWithApple delegates to platform instance', () async {
      final result = await plugin.signInWithApple();
      expect(result.provider, 'apple');
      expect(result.idToken, 'mock-apple-id-token');
      expect(result.email, 'user@example.com');
    });

    test('signOut delegates to platform instance', () async {
      expect(plugin.signOut(), completes);
    });
  });
}
