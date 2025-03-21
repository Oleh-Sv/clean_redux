import 'package:clean_redux/src/failure.dart';

class FailureOrResult<T> {
  final Failure? failure;
  final T? result;

  FailureOrResult.failure({
    required String code,
    required String message,
    Map<String, dynamic>? details,
    StackTrace? stackTrace,
    FailureType type = FailureType.exception,
  })  : failure = Failure(
          code: code,
          message: message,
          details: details,
          stackTrace: stackTrace,
          type: type,
        ),
        result = null;

  FailureOrResult.success(this.result) : failure = null;

  bool get hasFailed => failure != null;

  bool get wasSuccessful => failure == null;

  FailureOrResult<T2> map<T2>(T2 Function(T result) convert) => wasSuccessful
      ? FailureOrResult.success(convert(result as T))
      : FailureOrResult.failure(
          code: failure!.code,
          message: failure!.message,
          details: failure!.details,
          stackTrace: failure!.stackTrace,
          type: failure!.type,
        );
}
