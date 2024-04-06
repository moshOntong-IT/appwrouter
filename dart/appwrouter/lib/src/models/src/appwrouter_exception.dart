/// {@template appwrouter_exception}
/// A base exception for appwrouter
/// {@endtemplate}
class AppwrouterException implements Exception {
  /// {@macro appwrouter_exception}
  const AppwrouterException({
    required this.message,
    required this.status,
  });

  /// The message of the exception
  final String message;

  /// The status code of the exception
  final int status;

  @override
  String toString() {
    return message;
  }
}
