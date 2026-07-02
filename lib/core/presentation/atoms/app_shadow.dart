import 'package:flutter/material.dart';

class AppShadow {
  // Prevent class instantiation
  AppShadow._();

  /// Article Card Shadow
  static List<BoxShadow> get level1 => [
    BoxShadow(
      offset: const Offset(0, 2),
      blurRadius: 8,
      color: Colors.black.withValues(alpha: 0.05),
    ),
  ];

  /// Floating / Interactive Element
  static List<BoxShadow> get level2 => [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 12,
      color: Colors.black.withValues(alpha: 0.1),
    ),
  ];
}
