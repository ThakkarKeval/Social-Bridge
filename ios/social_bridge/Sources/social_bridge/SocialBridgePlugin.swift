import AuthenticationServices
import Flutter
import UIKit

public class SocialBridgePlugin: NSObject, FlutterPlugin, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  private var pendingResult: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "social_bridge", binaryMessenger: registrar.messenger())
    let instance = SocialBridgePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "signInWithApple":
      signInWithApple(result: result)
    case "signInWithGoogle":
      result(FlutterError(code: "UNSUPPORTED_PLATFORM", message: "Google Sign-In on iOS requires platform setup.", details: nil))
    case "signOut":
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func signInWithApple(result: @escaping FlutterResult) {
    guard pendingResult == nil else {
      result(FlutterError(code: "CONCURRENT_REQUEST", message: "An authentication request is already in progress.", details: nil))
      return
    }
    pendingResult = result

    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
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
      pendingResult?(FlutterError(code: "INVALID_CREDENTIAL", message: "Expected Apple ID credential.", details: nil))
      pendingResult = nil
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

    let authData: [String: Any?] = [
      "provider": "apple",
      "idToken": idToken,
      "accessToken": authCode,
      "email": appleIDCredential.email,
      "displayName": displayName,
      "photoUrl": nil,
      "userIdentifier": appleIDCredential.user
    ]

    pendingResult?(authData)
    pendingResult = nil
  }

  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    let nsError = error as NSError
    let code: String
    if nsError.domain == ASAuthorizationError.errorDomain && nsError.code == ASAuthorizationError.canceled.rawValue {
      code = "CANCELLED"
    } else {
      code = "FAILED"
    }
    pendingResult?(FlutterError(code: code, message: error.localizedDescription, details: nil))
    pendingResult = nil
  }
}
