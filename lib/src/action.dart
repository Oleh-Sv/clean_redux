import 'package:clean_redux/src/failure.dart';
import 'package:clean_redux/src/use_case.dart';

abstract mixin class Action {
  const Action();

  final List<Object?> properties = const [];

  bool get loggable => true;

  @override
  String toString() => '''Action ${DateTime.now()}
  Type: $runtimeType
  Data: ${properties.join('\n\t')}''';
}

class FailedAction<T extends UseCase> extends Action {
  Type get useCaseType => T;

  final Failure failure;

  FailedAction(this.failure);

  @override
  List<Object> get properties => [failure.code, failure.message];
}

class ResetFailureAction<T extends UseCase> extends Action {
  Type get useCaseType => T;

  const ResetFailureAction();
}
