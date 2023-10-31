import 'dart:async';

class DelayedTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration duration;

  DelayedTransformer(this.duration);

  @override
  Stream<T> bind(Stream<T> stream) {
    Timer? timer;
    final controller = StreamController<T>();

    stream.listen((event) {
      timer?.cancel();
      timer = Timer(
        duration,
        () => controller.add(event),
      );
    });

    return controller.stream;
  }
}
