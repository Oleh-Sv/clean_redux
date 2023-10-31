## Documentation

### `Action`

**Action** serves as the basis for representing events or operations. It encapsulates a list of properties and has a formatted `toString()` representation for better logging and debugging.

### `FailedAction<T extends UseCase>`

A specialized type of `Action`, **FailedAction** represents a failed operation related to a specific use case. It contains information about the failure, allowing for easier error handling in your application's logic.

### `Controller`

**Controller** is a manager for streams of data, representing different endpoints. When instantiated, it consolidates various streams and provides a unified iterator over these streams. It's especially useful when combined with middleware to manage complex app state operations.

### `Endpoint<T extends Action>`

An **Endpoint** represents the entry for handling specific actions. Depending on the nature of the use case (synchronous or asynchronous), it will use either `_AsyncEndpoint` or `_SyncEndpoint` to execute the associated logic.

### `_AsyncEndpoint<T extends Action>` and `_SyncEndpoint<T extends Action>`

Both are internal classes that provide the actual logic for handling asynchronous and synchronous actions respectively.

### `Reducer<TState extends State<TState>, TAction extends Action>`

**Reducer** is a function type that takes in a state and an action, and produces a new state. It's the cornerstone of Redux's state management. Additionally, the provided extensions on Reducer offer ways to compose and combine different reducers.

### `State<T extends State<T>>`

This abstract class represents a state in Redux. Each state can have its own logic (reducer) to update based on dispatched actions. Additionally, states can be copied with modifications using the `copyWith` method.

### `UseCase<T extends Action>`

A **UseCase** represents a set of business rules. Each use case defines how specific actions are handled and can either be asynchronous or synchronous. It also offers the ability to cancel the current execution, and to transform the input stream of actions, allowing for more flexible and modular logic.