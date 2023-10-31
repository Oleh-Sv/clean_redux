class Failure {
  final String code;
  final String message;

  Failure({
    required this.code,
    required this.message,
  });

  @override
  bool operator ==(Object other) => other is Failure && identical(this, other);

  @override
  int get hashCode => Object.hashAll([code, message]);
}
