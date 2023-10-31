import 'dart:async';

import 'package:clean_redux/clean_redux.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LaunchAction extends Action {}

class ResultAction extends Action {}

class CancelAction extends Action {}

class InteruptedAction extends Action {}

class TestUseCase extends Mock implements UseCase<LaunchAction> {
  @override
  bool get isAsync => true;

  @override
  Stream<Action> call(LaunchAction action, Stream<Action> actions) =>
      execute(action, actions, waitCancel(actions));
}

void main() {
  group('UseCase', () {
    late TestUseCase useCase;
    late StreamController<Action> actions;

    setUp(() {
      useCase = TestUseCase();
      actions = StreamController.broadcast();
      registerFallbackValue(LaunchAction());
      registerFallbackValue(Completer<void>().future);
      registerFallbackValue(actions.stream);
    });

    test('should execute the use case', () async {
      when(
        () => useCase.execute(any(), actions.stream, any()),
      ).thenAnswer((_) => Stream.value(ResultAction()));
      when(() => useCase.waitCancel(actions.stream))
          .thenAnswer((_) => Completer().future);

      final endpoint = Endpoint<LaunchAction>(useCase);

      final result = endpoint.execute(actions.stream);
      actions.add(LaunchAction());

      expect(await result.take(1).single, isA<ResultAction>());
    });

    test('cancelable use case', () async {
      when(() => useCase.waitCancel(any())).thenAnswer(
        (invocation) => invocation.positionalArguments[0]
            .firstWhere((element) => element is CancelAction),
      );
      when(
        () => useCase.execute(any(), actions.stream, any()),
      ).thenAnswer((invocation) async* {
        final completer = Completer();
        invocation.positionalArguments[2].then((_) => completer.complete());

        yield ResultAction();
        await Future.delayed(Duration(milliseconds: 100));
        if (completer.isCompleted) {
          yield InteruptedAction();
          return;
        }
        yield ResultAction();
      });

      final endpoint = Endpoint<LaunchAction>(useCase);

      final result = endpoint.execute(actions.stream);
      actions.add(LaunchAction());
      await Future.delayed(Duration.zero);
      actions.add(CancelAction());
      actions.add(LaunchAction());

      expect(
        await result.take(4).toList(),
        unorderedEquals([
          isA<ResultAction>(),
          isA<InteruptedAction>(),
          isA<ResultAction>(),
          isA<ResultAction>()
        ]),
      );
    });
  });
}
