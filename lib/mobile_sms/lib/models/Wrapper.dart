class Wrapper<T> {
  T? value;

  Wrapper({this.value});

  Wrapper<T> copy({T? value}) {
    return Wrapper(value: value ?? this.value);
  }
}