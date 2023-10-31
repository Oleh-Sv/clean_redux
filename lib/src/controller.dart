import 'package:clean_redux/src/state.dart';
import 'package:redux_epics/redux_epics.dart';

class Controller extends Iterable<
    Stream<dynamic> Function(Stream<dynamic> actions, EpicStore<State> store)> {
  final List<Stream<dynamic> Function(Stream<dynamic>, EpicStore<State>)>
      _endpoints;

  Controller(this._endpoints);

  @override
  Iterator<
      Stream<dynamic> Function(
          Stream<dynamic> actions, EpicStore<State> store)> get iterator =>
      _endpoints.iterator;
}
