import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  dartOptions: DartOptions(),
  kotlinOut:
      'android/src/main/kotlin/com/cavernlabs/social/bridge/social_bridge/Messages.g.kt',
  kotlinOptions: KotlinOptions(
    package: 'com.cavernlabs.social.bridge.social_bridge',
  ),
  swiftOut: 'ios/social_bridge/Sources/social_bridge/Messages.g.swift',
  swiftOptions: SwiftOptions(),
  cppHeaderOut: 'windows/messages.g.h',
  cppSourceOut: 'windows/messages.g.cpp',
  cppOptions: CppOptions(namespace: 'social_bridge'),
  gobjectHeaderOut: 'linux/messages.g.h',
  gobjectSourceOut: 'linux/messages.g.cc',
  gobjectOptions: GObjectOptions(module: 'SocialBridge'),
))
class NativeSocialAuthResult {
  NativeSocialAuthResult({
    required this.provider,
    this.idToken,
    this.accessToken,
    this.email,
    this.displayName,
    this.userIdentifier,
    this.photoUrl,
  });

  String provider;
  String? idToken;
  String? accessToken;
  String? email;
  String? displayName;
  String? userIdentifier;
  String? photoUrl;
}

class GoogleSignInRequest {
  GoogleSignInRequest({
    required this.serverClientId,
    this.nonce,
    this.filterByAuthorizedAccounts = false,
  });

  String serverClientId;
  String? nonce;
  bool filterByAuthorizedAccounts;
}

class AppleSignInRequest {
  AppleSignInRequest({this.scopes});

  List<String>? scopes;
}

@HostApi()
abstract class SocialBridgeHostApi {
  @async
  NativeSocialAuthResult signInWithGoogle(GoogleSignInRequest request);

  @async
  NativeSocialAuthResult signInWithApple(AppleSignInRequest request);

  @async
  void signOut();
}
