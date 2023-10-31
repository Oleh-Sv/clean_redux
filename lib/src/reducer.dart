import 'package:clean_redux/src/action.dart';
import 'package:clean_redux/src/state.dart';

typedef Reducer<TState extends State<TState>, TAction extends Action> = TState
    Function(TState, TAction);

extension ReducerExtension<TState extends State<TState>, T2 extends Action>
    on Reducer<TState, T2> {
  Reducer<TState, Action> get reducer =>
      (state, action) => action is T2 ? this(state, action) : state;
}

extension ReducerExtensionSum<TState extends State<TState>>
    on Reducer<TState, Action> {
  Reducer<TState, Action> operator +(Reducer<TState, Action> other) =>
      (state, action) => other(this(state, action), action);
}
