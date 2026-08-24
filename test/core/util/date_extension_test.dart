import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:news_app_clean_architecture/core/util/date_extension.dart';

/// Unit test suite for [DateStringFormatter] extension.
///
/// Verifies short date formatting and relative time calculation across various
/// edge cases including null, empty, unparseable, and valid ISO 8601 strings.

void main() {
  group('DateStringFormatter extension Unit Test', () {
    group('toShortDate', () {
      test('should return "Unknown Date" when string is null', () {
        // Arrange: Prepare null string reference
        const String? nullDate = null;

        // Act: Format null date string
        final result = nullDate.toShortDate();

        // Assert: Verify fallback message
        expect(result, equals('Unknown Date'));
      });

      test('should return "Unknown Date" when string is empty', () {
        // Arrange: Prepare empty string
        const emptyDate = "";

        // Act: Format empty string
        final result = emptyDate.toShortDate();

        // Assert: Verify fallback message
        expect(result, equals('Unknown Date'));
      });

      test('should return "Invalid Date" for unparseable raw string', () {
        // Arrange: Prepare corrupted date string
        const invalidDate = 'not-a-valid-iso-date';

        // Act: Format corrupted date string
        final result = invalidDate.toShortDate();

        // Assert: Verify invalid date fallback
        expect(result, equals('Invalid Date'));
      });

      test('should format valid ISO 8601 date string to "MMM d, yyyy"', () {
        // Arrange: Prepare standard ISO 8601 UTC date string
        const isoDate = '2025-09-12T00:00:00Z';

        // Act: Format date string
        final result = isoDate.toShortDate();

        // Assert: Verify correct formatting
        expect(result, equals('Sep 12, 2025'));
      });
    });

    group('toTimeAgo', () {
      test('should return "Unknown Date" when string is null or empty', () {
        // Arrange: Prepare null and empty references
        const String? nullDate = null;
        const emptyDate = '';

        // Assert: Verify both return 'Unknown Date'
        expect(nullDate.toTimeAgo(), equals('Unknown Date'));
        expect(emptyDate.toTimeAgo(), equals('Unknown Date'));
      });

      test('should return "Invalid Date" for unparseable raw string', () {
        // Arrange: Prepare invalid string
        const invalidDate = 'corrupted-timestamp';

        // Act: Evaluate relative time on invalid string
        final result = invalidDate.toTimeAgo();

        // Assert: Verify invalid date fallback
        expect(result, equals('Invalid Date'));
      });

      test('should return "Just now" when date is less than 1 minute ago', () {
        // Arrange: Generate timestamp 30 seconds before now
        final now = DateTime.now();
        final pastDate = now
            .subtract(const Duration(seconds: 30))
            .toIso8601String();

        // Act: Calculate relative time
        final result = pastDate.toTimeAgo();

        // Assert: Verify 'Just now' threshold
        expect(result, equals('Just now'));
      });

      test('should return "1 minute ago" for 1 minute duration', () {
        // Arrange: Generate timestamp 1 minute before now
        final now = DateTime.now();
        final pastDate = now
            .subtract(const Duration(minutes: 1))
            .toIso8601String();

        // Act: Calculate relative time
        final result = pastDate.toTimeAgo();

        // Assert: Verify singular minute output
        expect(result, equals('1 minute ago'));
      });

      test('should return "X minutes ago" for plural minutes duration', () {
        // Arrange: Generate timestamp 15 minutes before now
        final now = DateTime.now();
        final pastDate = now
            .subtract(const Duration(minutes: 15))
            .toIso8601String();
        // Act: Calculate relative time
        final result = pastDate.toTimeAgo();
        // Assert: Verify plural minutes output
        expect(result, equals('15 minutes ago'));
      });

      test('should return "1 hour ago" for singular hour duration', () {
        // Arrange: Generate timestamp 1 hour before now
        final now = DateTime.now();
        final pastDate = now
            .subtract(const Duration(hours: 1))
            .toIso8601String();
        // Act: Calculate relative time
        final result = pastDate.toTimeAgo();
        // Assert: Verify singular hour output
        expect(result, equals('1 hour ago'));
      });
      test('should return "X hours ago" for plural hours duration', () {
        // Arrange: Generate timestamp 5 hours before now
        final now = DateTime.now();
        final pastDate = now
            .subtract(const Duration(hours: 5))
            .toIso8601String();
        // Act: Calculate relative time
        final result = pastDate.toTimeAgo();
        // Assert: Verify plural hours output
        expect(result, equals('5 hours ago'));
      });
      test('should return "Yesterday" when date is 1 day ago', () {
        // Arrange: Generate timestamp 1 day before now
        final now = DateTime.now();
        final pastDate = now
            .subtract(const Duration(days: 1))
            .toIso8601String();
        // Act: Calculate relative time
        final result = pastDate.toTimeAgo();
        // Assert: Verify 'Yesterday' output
        expect(result, equals('Yesterday'));
      });
      test('should return "X days ago" for 2 to 6 days duration', () {
        // Arrange: Generate timestamp 4 days before now
        final now = DateTime.now();
        final pastDate = now
            .subtract(const Duration(days: 4))
            .toIso8601String();
        // Act: Calculate relative time
        final result = pastDate.toTimeAgo();
        // Assert: Verify plural days output
        expect(result, equals('4 days ago'));
      });
      test('should return "1 week ago" when date is exactly 7 days ago', () {
        // Arrange: Generate timestamp 7 days before now
        final now = DateTime.now();
        final pastDate = now
            .subtract(const Duration(days: 7))
            .toIso8601String();
        // Act: Calculate relative time
        final result = pastDate.toTimeAgo();
        // Assert: Verify '1 week ago' threshold
        expect(result, equals('1 week ago'));
      });
      test(
        'should fallback to "MMM d, yyyy" when date is older than 7 days',
        () {
          // Arrange: Generate timestamp 10 days before now
          final now = DateTime.now();
          final pastDateTime = now.subtract(const Duration(days: 10));
          final pastDateString = pastDateTime.toIso8601String();
          final expectedFormattedDate = DateFormat(
            'MMM d, yyyy',
          ).format(pastDateTime);
          // Act: Calculate relative time
          final result = pastDateString.toTimeAgo();
          // Assert: Verify formatted date fallback
          expect(result, equals(expectedFormattedDate));
        },
      );
    });
  });
}
