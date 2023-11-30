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
  CancelToken waitCancel(Stream<Action> actions) {
    final token = CancelToken();
    actions.listen((event) {
      if (event is CancelAction) {
        onCancel();
        token.cancel();
      }
    });

    return token;
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
      when(() => useCase.waitCancel(actions.stream))
          .thenAnswer((_) => CancelToken());

      final endpoint = Endpoint<LaunchAction>(useCase);

      final result = endpoint.execute(actions.stream);
      actions.add(LaunchAction());

      expect(await result.take(1).single, isA<ResultAction>());
    });

    test('cancelable use case', () async {
      when(() => useCase.waitCancel(any())).thenAnswer((invocation) {
        final token = CancelToken();
        invocation.positionalArguments[0].listen((event) {
          if (event is CancelAction) {
            token.cancel();
          }
        });
        return token;
      });
      when(
        () => useCase.execute(any(), actions.stream, any()),
      ).thenAnswer((invocation) async* {
        final completer = Completer();
        invocation.positionalArguments[2]
            .addListener(() => completer.complete());

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
