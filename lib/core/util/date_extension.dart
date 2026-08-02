import 'package:intl/intl.dart';

/// Extension utility providing date formatting and relative time conversions for ISO 8601 date strings.
extension DateStringFormatter on String? {
  /// Converts an ISO 8601 date string (e.g., '2025-09-12T00:00:00Z') into a short date string (e.g., 'Sep 12, 2025').
  String toShortDate() {
    // Return fallback if string is null or empty
    if (this == null || this!.isEmpty) return 'Unknown Date';

    try {
      final DateTime parsedDate = DateTime.parse(this!);
      return DateFormat('MMM d, yyyy').format(parsedDate);
    } catch (e) {
      // Fallback for unparseable raw date string payload
      return 'Invalid Date';
    }
  }

  /// Converts an ISO 8601 date string into a human-readable relative time string (e.g., '4 hours ago', 'Yesterday').
  ///
  /// Falls back to [toShortDate] formatting if the date is older than 1 week.
  String toTimeAgo() {
    // Return fallback if string is null or empty
    if (this == null || this!.isEmpty) return 'Unknown Date';

    try {
      final DateTime parsedDate = DateTime.parse(this!);
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(parsedDate);

      // Evaluate relative duration threshold
      if (difference.inDays > 7) {
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
        return 'Just now';
      }
    } catch (e) {
      // Fallback for unparseable raw date string payload
      return 'Invalid Date';
    }
  }
}

