class Nullable<T extends Object> {
  final T? value;

  Nullable([this.value]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Nullable<T> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}
