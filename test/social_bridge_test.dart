import 'package:flutter_test/flutter_test.dart';
import 'package:social_bridge/social_bridge.dart';
import 'package:social_bridge/social_bridge_platform_interface.dart';
import 'package:social_bridge/social_bridge_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSocialBridgePlatform
    with MockPlatformInterfaceMixin
    implements SocialBridgePlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SocialBridgePlatform initialPlatform = SocialBridgePlatform.instance;

  test('$MethodChannelSocialBridge is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSocialBridge>());
  });

  test('getPlatformVersion', () async {
    SocialBridge socialBridgePlugin = SocialBridge();
    MockSocialBridgePlatform fakePlatform = MockSocialBridgePlatform();
    SocialBridgePlatform.instance = fakePlatform;

    expect(await socialBridgePlugin.getPlatformVersion(), '42');
  });
}
