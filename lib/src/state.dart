import 'package:clean_redux/src/action.dart';
import 'package:clean_redux/src/reducer.dart';

/// An abstract class representing the state of a Redux store.
///
/// The type parameter `T` represents the concrete implementation of the state.
/// The `Reducer` class is used to define how the state should be updated in response to actions.
abstract class State<T extends State<T>> {
  final Reducer<T, Action> _reducer;

  /// A method that applies the reducer to the current state and an action, returning a new state.
  T reducer(T state, Action action) => _reducer(state, action);

  /// Constructor that takes a reducer as a parameter.
  State(this._reducer);

  /// A method that creates a copy of the current state.
  T copyWith();
}
