/// Extension utility providing helper methods for nullable string evaluation.
extension StringExtension on String? {
  /// Evaluates whether the string is null, empty, or contains only whitespace characters.
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  /// Returns [fallback] string if the target string is null or empty.
  String valueOr(String fallback) {
    if (isNullOrEmpty) return fallback;
    return this!;
  }
}

