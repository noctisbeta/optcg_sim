extension ListExtension<T> on List<T> {
  List<T> reverseWhen(bool condition) {
    if (condition) {
      return reversed.toList();
    }
    return this;
  }
}
