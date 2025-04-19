extension ListExtension<T> on List<T> {
  // Cleaner if not named.
  // ignore: avoid_positional_boolean_parameters
  List<T> reverseWhen(bool condition) {
    if (condition) {
      return reversed.toList();
    }
    return this;
  }
}
