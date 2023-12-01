import 'dart:async';

import 'package:clean_redux/clean_redux.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class LaunchAction extends Action {}

class ResultAction extends Action {}

class CancelAction extends Action {}

class InteruptedAction extends Action {}

class TestUseCase extends UseCase<LaunchAction> {
  TestUseCase() : super(isAsync: true);

  @override
  void waitCancel(Stream<Action> actions, CancelToken token) {
    actions.listen((event) {
      if (event is CancelAction) {
        token.cancel();
      }
    });
  }

  @override
  Stream<Action> execute(
    LaunchAction action,
    Stream<Action> actions,
    CancelToken cancel,
  ) async* {
    final completer = Completer();
    cancel.addListener(() => completer.complete());

    yield ResultAction();
    await Future.delayed(Duration(milliseconds: 100));
    if (completer.isCompleted) {
      yield InteruptedAction();
      return;
    }
    yield ResultAction();
  }
}

class CancelableTestCase extends UseCase<LaunchAction> {
  final void Function() onCancel;

  CancelableTestCase(this.onCancel) : super(isAsync: true);

  @override
  Stream<Action> execute(
    LaunchAction action,
    Stream<Action> actions,
    CancelToken cancel,
  ) async* {
    yield ResultAction();
  }

  @override
  void waitCancel(Stream<Action> actions, CancelToken token) {
    actions.listen((event) {
      if (event is CancelAction) {
        onCancel();
        token.cancel();
      }
    });
  }
}

void main() {
  group('UseCase', () {
    late TestUseCase useCase;
    late StreamController<Action> actions;

    setUp(() {
      useCase = TestUseCase();
      actions = StreamController.broadcast();
      registerFallbackValue(LaunchAction());
      registerFallbackValue(CancelToken());
      registerFallbackValue(actions.stream);
    });

    test('should execute the use case', () async {
      when(
        () => useCase.execute(any(), actions.stream, any()),
      ).thenAnswer((_) => Stream.value(ResultAction()));

      final endpoint = Endpoint<LaunchAction>(useCase);

      final result = endpoint.execute(actions.stream);
      actions.add(LaunchAction());

      expect(await result.take(1).single, isA<ResultAction>());
    });

    test('cancelable use case', () async {
      final actions = StreamController<Action>.broadcast();
      final endpoint = Endpoint<LaunchAction>(TestUseCase());
      final result = endpoint.execute(actions.stream);

      await Future.delayed(Duration.zero);
      actions.add(LaunchAction());
      await Future.delayed(Duration.zero);

      actions.add(CancelAction());
      await Future.delayed(Duration.zero);
      actions.add(LaunchAction());

      expect(
        result,
        emitsInAnyOrder([
          isA<ResultAction>(),
          isA<InteruptedAction>(),
          isA<ResultAction>(),
          isA<ResultAction>(),
        ]),
      );
    });

    test(
      'double cancel',
      () async {
        var counter = 0;
        final useCase = CancelableTestCase(() {
          counter++;
        });

        final actions = StreamController<Action>.broadcast();
        final results = useCase.call(LaunchAction(), actions.stream);

        final q = await results.toList();
        actions.add(CancelAction());

        await Future.delayed(Duration(milliseconds: 100));

        expect(q.length, 1);
        expect(counter, 0);
      },
    );
  });
}
