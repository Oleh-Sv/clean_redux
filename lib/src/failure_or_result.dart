import 'package:clean_redux/src/failure.dart';

class FailureOrResult<T> {
  final Failure? failure;
  final T? result;

  FailureOrResult.failure({
    required String code,
    required String message,
    Map<String, dynamic>? details,
    FailureType type = FailureType.exception,
  })  : failure = Failure(
          code: code,
          message: message,
          type: type,
          details: details,
        ),
        result = null;

  FailureOrResult.success(this.result) : failure = null;

  bool get hasFailed => failure != null;

  bool get wasSuccessful => failure == null;

  FailureOrResult<T2> map<T2>(T2 Function(T result) convert) {
    if (wasSuccessful) {
      return FailureOrResult.success(convert(result as T));
    } else {
      return FailureOrResult.failure(
        code: failure!.code,
        message: failure!.message,
      );
    }
  }
}
