/// Represents the unified outcome of a successful social authentication.
class SocialAuthResult {
  /// The identity provider name (e.g. `'google'`, `'apple'`).
  final String provider;

  /// The OpenID Connect ID token returned by the provider, if available.
  final String? idToken;

  /// The OAuth access token or authorization code, if provided.
  final String? accessToken;

  /// The email address associated with the authenticated account, if available.
  final String? email;

  /// The user's full display name, if available.
  final String? displayName;

  /// A unique, stable identifier for the user from the provider (e.g. Apple user sub or Google user ID).
  final String? userIdentifier;

  /// The profile picture URL, if available.
  final String? photoUrl;

  /// The complete raw payload returned by the underlying platform SDK.
  final Map<String, dynamic> rawData;

  /// Creates a [SocialAuthResult] with the provided authentication fields.
  const SocialAuthResult({
    required this.provider,
    this.idToken,
    this.accessToken,
    this.email,
    this.displayName,
    this.userIdentifier,
    this.photoUrl,
    this.rawData = const {},
  });

  /// Constructs a [SocialAuthResult] from a platform channel map response.
  factory SocialAuthResult.fromMap(Map<dynamic, dynamic> map) {
    return SocialAuthResult(
      provider: map['provider'] as String? ?? '',
      idToken: map['idToken'] as String?,
      accessToken: map['accessToken'] as String?,
      email: map['email'] as String?,
      displayName: map['displayName'] as String?,
      userIdentifier: map['userIdentifier'] as String?,
      photoUrl: map['photoUrl'] as String?,
      rawData: Map<String, dynamic>.from(map['rawData'] as Map? ?? map),
    );
  }

  /// Converts this [SocialAuthResult] into a map.
  Map<String, dynamic> toMap() => {
    'provider': provider,
    'idToken': idToken,
    'accessToken': accessToken,
    'email': email,
    'displayName': displayName,
    'userIdentifier': userIdentifier,
    'photoUrl': photoUrl,
    'rawData': rawData,
  };

  @override
  String toString() =>
      'SocialAuthResult(provider: $provider, email: $email, displayName: $displayName, userIdentifier: $userIdentifier)';
}
