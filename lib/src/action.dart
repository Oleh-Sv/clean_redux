import 'package:clean_redux/src/failure.dart';
import 'package:clean_redux/src/use_case.dart';

abstract class Action {
  const Action();

  final List<Object?> properties = const [];

  @override
  String toString() => '''Action ${DateTime.now()}
  Type: $runtimeType.toString()
  Data: ${properties.join('\n\t')}''';
}

class FailedAction<T extends UseCase> extends Action {
  final Failure failure;

  FailedAction(this.failure);

  @override
  List<Object> get properties => [failure.code, failure.message];
}

class ResetFailureAction<T extends UseCase> extends Action {
  const ResetFailureAction();
}
