enum FailureType { exception, message, debug }

class Failure {
  final String code;
  final String message;
  final FailureType type;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? details;

  Failure({
    required this.code,
    required this.message,
    this.type = FailureType.exception,
    this.stackTrace,
    this.details,
  });

  @override
  bool operator ==(Object other) => other is Failure && identical(this, other);

  @override
  int get hashCode => Object.hashAll([code, message]);
}
