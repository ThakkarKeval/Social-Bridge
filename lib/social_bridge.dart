
import 'social_bridge_platform_interface.dart';

class SocialBridge {
  Future<String?> getPlatformVersion() {
    return SocialBridgePlatform.instance.getPlatformVersion();
  }
}
