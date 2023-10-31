import 'package:clean_redux/src/failure.dart';
import 'package:clean_redux/src/use_case.dart';

abstract class Action extends Object {
  final List<Object?> properties = [];

  @override
  String toString() => '''Action ${DateTime.now()}
  Type: $runtimeType
  Data: ${properties.join('\n\t')}''';
}

class FailedAction<T extends UseCase> extends Action {
  final Failure failure;

  FailedAction(this.failure);

  @override
  List<Object> get properties => [failure.code, failure.message];
}
