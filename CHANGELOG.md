## 0.1.0

* Migrated native platform channels to Pigeon for type-safe cross-platform communication across Android, iOS, macOS, Windows, and Linux.
* Updated Android implementation to use Kotlin coroutines with Pigeon host API.
* Updated iOS and macOS implementations to use Swift async/await with Pigeon host API.
* Added Windows (C++) and Linux (GObject) native Pigeon bindings.
* Added `meta` dependency to support generated annotations.

## 0.0.3

* Added comprehensive dartdoc documentation comments across all public APIs.
* Fixed link formatting in README.
* Bumped version and updated repository metadata.

## 0.0.2

* Updated LICENSE file with MIT License.
* Added repository and false_secrets configuration for clean pub.dev publishing.
* Enhanced Credential Manager session clearing on sign-out.

## 0.0.1

* Initial release of `social_bridge`.
* Google Sign-In with Android Credential Manager (`androidx.credentials`).
* Apple Sign-In with Firebase Auth OAuthProvider on Android and AuthenticationServices on iOS.
* Unified `SocialAuthResult` and typed exceptions (`SocialAuthException`, `SocialAuthCancelledException`).
* Cross-platform sign-out support.
