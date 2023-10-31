import 'dart:async';

import 'package:clean_redux/src/action.dart';

///The UseCase class is used in the context of clean architecture to
///represent a single use case or business logic of an application.
///It is an abstract class that defines a single method called execute, which
///takes an input object and returns an output object. The execute method is
///responsible for executing the business logic of the use case and returning
///the appropriate output stream.
///
///
///By using the UseCase class, developers can
///separate the business logic of an application from the presentation and data
///layers. This allows for greater flexibility and maintainability of the
///codebase, as changes to one layer do not affect the others. Additionally,
///it makes it easier to test the business logic in isolation from the rest of
///the application.
///
///
///Overall, the UseCase class is an important part of implementing clean
///architecture in application.

abstract class UseCase<T extends Action> {
  ///If isAsync == false we can't launch next execute until complete current
  final bool isAsync;

  ///Transofrmer for list of launch actions (first param of execute)
  final StreamTransformer<T, T>? transformer;

  UseCase({
    required this.isAsync,
    this.transformer,
  });

  ///It should contain logic that can stop executing of use case after some action
  Future<void> waitCancel(Stream<Action> actions) => Completer().future;

  Stream<Action> execute(T action, Stream<Action> actions, Future<void> cancel);

  Stream<Action> call(T action, Stream<Action> actions) =>
      execute(action, actions, waitCancel(actions));
}
