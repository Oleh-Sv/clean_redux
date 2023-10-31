import 'dart:async';

import 'package:clean_redux/src/action.dart';
import 'package:clean_redux/src/state.dart';
import 'package:clean_redux/src/use_case.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

abstract class Endpoint<T extends Action> extends EpicClass<State> {
  final UseCase<T> useCase;

  Endpoint._(this.useCase);

  factory Endpoint(UseCase<T> useCase) =>
      useCase.isAsync ? _AsyncEndpoint(useCase) : _SyncEndpoint(useCase);

  Stream<Action> execute(Stream<Action> actions);

  @override
  Stream call(Stream actions, EpicStore<State> store) =>
      execute(actions.whereType<Action>());
}

class _AsyncEndpoint<T extends Action> extends Endpoint<T> {
  _AsyncEndpoint(UseCase<T> useCase) : super._(useCase);

  @override
  Stream<Action> execute(Stream<Action> actions) {
    final actionsController = StreamController<Action>();
    final launchActions = actions.whereType<T>();
    final transformer = useCase.transformer;
    final transformedActions = transformer == null
        ? launchActions
        : launchActions.transform(transformer);

    transformedActions.listen(
      (event) => useCase.call(event, actions).forEach(actionsController.add),
      onDone: () => actionsController.close(),
    );

    return actionsController.stream;
  }
}

class _SyncEndpoint<T extends Action> extends Endpoint<T> {
  _SyncEndpoint(UseCase<T> useCase) : super._(useCase);

  @override
  Stream<Action> execute(Stream<Action> actions) {
    final launchActions = actions.whereType<T>();
    final transformer = useCase.transformer;
    final transformedActions = transformer == null
        ? launchActions
        : launchActions.transform(transformer);

    return transformedActions
        .exhaustMap((action) => useCase(action, actions.whereType<Action>()));
  }
}
