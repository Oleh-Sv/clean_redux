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

  Failure copyWith({
    String? code,
    String? message,
    FailureType? type,
    StackTrace? stackTrace,
    Map<String, dynamic>? details,
  }) =>
      Failure(
        code: code ?? this.code,
        message: message ?? this.message,
        type: type ?? this.type,
        stackTrace: stackTrace ?? this.stackTrace,
        details: details ?? this.details,
      );
}
