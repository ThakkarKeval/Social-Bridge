import Cocoa
import FlutterMacOS

public class SocialBridgePlugin: NSObject, FlutterPlugin, SocialBridgeHostApi {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SocialBridgePlugin()
    SocialBridgeHostApiSetup.setUp(binaryMessenger: registrar.messenger, api: instance)
  }

  public func signInWithGoogle(request: GoogleSignInRequest) async throws -> NativeSocialAuthResult {
    throw PigeonError(code: "UNSUPPORTED_PLATFORM", message: "Google Sign-In is not supported on macOS.", details: nil)
  }

  public func signInWithApple(request: AppleSignInRequest) async throws -> NativeSocialAuthResult {
    throw PigeonError(code: "UNSUPPORTED_PLATFORM", message: "Apple Sign-In is not supported on macOS.", details: nil)
  }

  public func signOut() async throws {
    // No-op on macOS
  }
}
