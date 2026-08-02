import 'package:flutter/material.dart';

/// Centralized design system corner radius tokens and pre-configured [BorderRadius] getters.
class AppRadius {
  AppRadius._();

  // Radius Values
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 24.0;
  static const double pill = 9999.0;

  // BorderRadius Pre-configured Objects
  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get pillRadius => BorderRadius.circular(pill);
}
