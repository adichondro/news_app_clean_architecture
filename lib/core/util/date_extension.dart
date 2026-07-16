import 'package:intl/intl.dart';

extension DateStringFormatter on String? {
  /// Converts an ISO 8601 date string (e.g., '2025-09-12T00:00:00Z')
  /// into a human-readable format like 'Sep 12, 2025'.
  String toShortDate() {
    // Return early if the string is null or empty
    if (this == null || this!.isEmpty) return 'Unknown Date';

    try {
      // Parse the raw string into a Dart DateTime object
      final DateTime parsedDate = DateTime.parse(this!);

      // Format the DateTime object using the intl package
      // 'MMM' = Sep, 'd' = 12, 'yyyy' = 2025
      return DateFormat('MMM d, yyyy').format(parsedDate);
    } catch (e) {
      // Return a fallback string if the parsing fails
      // (e.g., the backend sends an invalid date format)
      return 'Invalid Date';
    }
  }

  /// Converts an ISO 8601 date string into a relative time ago format.
  /// Examples: 'Just now', '4 hours ago', 'Yesterday', '2 days ago', '1 week ago'.
  /// If the date is older than 1 week, it falls back to the short date format.
  String toTimeAgo() {
    // Return early if the string is null or empty
    if (this == null || this!.isEmpty) return 'Unknown Date';

    try {
      // Parse the raw string into a Dart DateTime object
      final DateTime parsedDate = DateTime.parse(this!);
      final DateTime now = DateTime.now();
      
      // Calculate the difference between current time and the parsed date
      final Duration difference = now.difference(parsedDate);

      // Check the duration and return the appropriate relative string
      if (difference.inDays > 7) {
        // Fallback to strict date format if older than 1 week
        return DateFormat('MMM d, yyyy').format(parsedDate);
      } else if (difference.inDays == 7) {
        return '1 week ago';
      } else if (difference.inDays >= 2) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        // If the difference is less than a minute
        return 'Just now';
      }
    } catch (e) {
      // Return a fallback string if the parsing fails
      return 'Invalid Date';
    }
  }
}
