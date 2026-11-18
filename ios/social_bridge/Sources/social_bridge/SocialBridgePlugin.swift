import AuthenticationServices
import Flutter
import UIKit

public class SocialBridgePlugin: NSObject, FlutterPlugin, SocialBridgeHostApi, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  private var appleContinuation: CheckedContinuation<NativeSocialAuthResult, Error>?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SocialBridgePlugin()
    SocialBridgeHostApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
  }

  public func signInWithGoogle(request: GoogleSignInRequest) async throws -> NativeSocialAuthResult {
    throw PigeonError(code: "UNSUPPORTED_PLATFORM", message: "Google Sign-In on iOS requires platform setup.", details: nil)
  }

  public func signInWithApple(request: AppleSignInRequest) async throws -> NativeSocialAuthResult {
    guard appleContinuation == nil else {
      throw PigeonError(code: "CONCURRENT_REQUEST", message: "An authentication request is already in progress.", details: nil)
    }

    return try await withCheckedThrowingContinuation { continuation in
      self.appleContinuation = continuation

      let provider = ASAuthorizationAppleIDProvider()
      let authRequest = provider.createRequest()
      var requestedScopes: [ASAuthorization.Scope] = []
      if let scopes = request.scopes {
        if scopes.contains("email") { requestedScopes.append(.email) }
        if scopes.contains("name") || scopes.contains("fullName") { requestedScopes.append(.fullName) }
      } else {
        requestedScopes = [.fullName, .email]
      }
      authRequest.requestedScopes = requestedScopes

      let controller = ASAuthorizationController(authorizationRequests: [authRequest])
      controller.delegate = self
      controller.presentationContextProvider = self
      controller.performRequests()
    }
  }

  public func signOut() async throws {
    // No-op on iOS
  }

  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
      return window
    }
    return UIApplication.shared.windows.first ?? UIWindow()
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
      appleContinuation?.resume(throwing: PigeonError(code: "INVALID_CREDENTIAL", message: "Expected Apple ID credential.", details: nil))
      appleContinuation = nil
      return
    }

    let idToken = appleIDCredential.identityToken.flatMap { String(data: $0, encoding: .utf8) }
    let authCode = appleIDCredential.authorizationCode.flatMap { String(data: $0, encoding: .utf8) }

    var displayName: String? = nil
    if let nameComponents = appleIDCredential.fullName {
      let formatted = PersonNameComponentsFormatter().string(from: nameComponents).trimmingCharacters(in: .whitespacesAndNewlines)
      if !formatted.isEmpty {
        displayName = formatted
      }
    }

    let result = NativeSocialAuthResult(
      provider: "apple",
      idToken: idToken,
      accessToken: authCode,
      email: appleIDCredential.email,
      displayName: displayName,
      userIdentifier: appleIDCredential.user,
      photoUrl: nil
    )

    appleContinuation?.resume(returning: result)
    appleContinuation = nil
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    let nsError = error as NSError
    let code: String
    if nsError.domain == ASAuthorizationError.errorDomain && nsError.code == ASAuthorizationError.canceled.rawValue {
      code = "CANCELLED"
    } else {
      code = "FAILED"
    }
    appleContinuation?.resume(throwing: PigeonError(code: code, message: error.localizedDescription, details: nil))
    appleContinuation = nil
  }
}
