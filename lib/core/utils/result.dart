sealed class Result<T, E> {
  const Result();

  R fold<R>({required R Function(T value) ok, required R Function(E error) err});

  bool get isOk => this is Ok<T, E>;
  bool get isErr => this is Err<T, E>;

  T? get valueOrNull => switch (this) {
        Ok<T, E>(value: final v) => v,
        Err<T, E>() => null,
      };

  E? get errorOrNull => switch (this) {
        Err<T, E>(error: final e) => e,
        Ok<T, E>() => null,
      };
}

final class Ok<T, E> extends Result<T, E> {
  const Ok(this.value);
  final T value;

  @override
  R fold<R>({required R Function(T value) ok, required R Function(E error) err}) {
    return ok(value);
  }
}

final class Err<T, E> extends Result<T, E> {
  const Err(this.error);
  final E error;

  @override
  R fold<R>({required R Function(T value) ok, required R Function(E error) err}) {
    return err(error);
  }
}
