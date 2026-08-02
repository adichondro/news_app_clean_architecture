import 'package:flutter/material.dart';

/// Centralized design system shadow elevation tokens.
class AppShadow {
  AppShadow._();

  // Elevation Levels
  static List<BoxShadow> get level1 => [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 8,
      color: Colors.black.withValues(alpha: 0.05),
    ),
  ];

  static List<BoxShadow> get level2 => [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 12,
      color: Colors.black.withValues(alpha: 0.1),
    ),
  ];
}
