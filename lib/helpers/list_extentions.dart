extension IterableExtension<T> on Iterable<T> {
  T? tryElementAt(int index) {
    var elementIndex = 0;
    for (var element in this) {
      if (index == elementIndex) return element;
      elementIndex++;
    }
    return null;
  }

  T? get tryFirst {
    try {
      return first;
    } catch (e) {
      return null;
    }
  }

  T? get tryLast {
    try {
      return last;
    } catch (e) {
      return null;
    }
  }

  T? tryFirstWhere(bool Function(T element) test, {T Function()? orElse}) {
    try {
      return firstWhere(test, orElse: orElse);
    } catch (e) {
      return null;
    }
  }

  //Map function with a index
  //Most usefull when popluting data in a Column widget from a list source
  Iterable<E> mapIndexed<E>(E Function(int index, T item) f) sync* {
    var index = 0;
    for (final item in this) {
      yield f(index, item);
      index = index + 1;
    }
  }
}
