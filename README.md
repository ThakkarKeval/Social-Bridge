# social_bridge

A modern, lightweight Flutter plugin for social authentication.

- **Google Sign-In**: Powered by the modern **Android Credential Manager** (`androidx.credentials` + `GoogleIdTokenCredential`), replacing deprecated legacy sign-in clients.
- **Apple Sign-In**: Integrated with **Firebase Auth OAuthProvider** on Android and native **AuthenticationServices** on iOS.
- **Decoupled Architecture**: Returns raw tokens (`idToken`, `accessToken`, etc.) in a unified [`SocialAuthResult`](class://SocialAuthResult) for use with custom backends or Firebase Auth.

---

## Getting Started

### 1. Google Sign-In Setup

Obtain your **Web Client ID** from the [Google Cloud Console](https://console.cloud.google.com/) (APIs & Services > Credentials > OAuth 2.0 Client IDs > Web application).

### 2. Apple Sign-In Setup

- **Android**: Ensure Firebase Authentication is enabled in your Firebase Console and the Apple sign-in provider is configured.
- **iOS**: Enable the **Sign in with Apple** capability in your Xcode project.

---

## Usage

```dart
import 'package:social_bridge/social_bridge.dart';

final socialBridge = const SocialBridge();

// Google Sign-In
try {
  final result = await socialBridge.signInWithGoogle(
    serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
  );
  print('Signed in: ${result.email}, ID Token: ${result.idToken}');
} on SocialAuthCancelledException {
  print('User cancelled Google Sign-In.');
} on SocialAuthException catch (e) {
  print('Google Sign-In failed: ${e.code} - ${e.message}');
}

// Apple Sign-In
try {
  final result = await socialBridge.signInWithApple();
  print('Signed in: ${result.email ?? result.userIdentifier}, ID Token: ${result.idToken}');
} on SocialAuthCancelledException {
  print('User cancelled Apple Sign-In.');
} on SocialAuthException catch (e) {
  print('Apple Sign-In failed: ${e.code} - ${e.message}');
}

// Sign Out
await socialBridge.signOut();
```
