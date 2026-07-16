extension StringExtension on String? {
  /// Returns true if the string is null or contains only whitespace.
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  /// Provides a fallback value if the string is null or empty.
  String valueOr(String fallback) {
    if (isNullOrEmpty) return fallback;
    return this!;
  }
}
