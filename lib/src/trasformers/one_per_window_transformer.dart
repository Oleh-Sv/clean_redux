import 'dart:async';

class OnePerWindowTransformer<T extends Object>
    extends StreamTransformerBase<T, T> {
  final Duration window;

  OnePerWindowTransformer(this.window);
  @override
  Stream<T> bind(Stream<T> stream) {
    T? last;

    stream.listen((event) => last = event);
    final controller = StreamController<T>.broadcast();
    Timer.periodic(window, (timer) {
      if (last != null) {
        controller.add(last!);
        last = null;
      }
    });
    return controller.stream;
  }
}
