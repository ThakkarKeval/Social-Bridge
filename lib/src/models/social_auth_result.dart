class SocialAuthResult {
  final String provider;
  final String? idToken;
  final String? accessToken;
  final String? email;
  final String? displayName;
  final String? userIdentifier;
  final String? photoUrl;
  final Map<String, dynamic> rawData;

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
