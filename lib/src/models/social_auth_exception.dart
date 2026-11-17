/// Exception thrown when a social authentication request fails.
class SocialAuthException implements Exception {
  /// The error code identifying the failure reason.
  final String code;

  /// A descriptive message explaining the error.
  final String message;

  /// Additional platform-specific error details, if available.
  final dynamic details;

  /// Creates a [SocialAuthException] with the given error [code], [message], and optional [details].
  const SocialAuthException({
    required this.code,
    required this.message,
    this.details,
  });

  @override
  String toString() => 'SocialAuthException($code: $message)';
}

/// Exception thrown when the user dismisses or cancels the social authentication prompt.
class SocialAuthCancelledException extends SocialAuthException {
  /// Creates a [SocialAuthCancelledException].
  const SocialAuthCancelledException({
    super.code = 'CANCELLED',
    super.message = 'Authentication was cancelled by the user.',
    super.details,
  });
}
