import 'package:flutter/material.dart';

class AppRadius {
  // Prevent class instantiation
  AppRadius._();

  /// Small Components (Chips, Small Buttons) - 8px
  static const double small = 8.0;

  /// Medium Components (Cards, Input Fields) - 12px
  static const double medium = 12.0;

  /// Large Components (Modals, Bottom Sheets) - 24px
  static const double large = 24.0;

  // Pre-configured BorderRadius objects for convenience
  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
}
