class SocialAuthException implements Exception {
  final String code;
  final String message;
  final dynamic details;

  const SocialAuthException({
    required this.code,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'SocialAuthException($code: $message)';
}

class SocialAuthCancelledException extends SocialAuthException {
  const SocialAuthCancelledException({
    super.code = 'CANCELLED',
    super.message = 'Authentication was cancelled by the user.',
    super.details,
  });
}
