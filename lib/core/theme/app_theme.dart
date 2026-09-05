import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_colors.dart';
import 'package:news_app_clean_architecture/core/theme/tokens/app_typography.dart';

/// Backward-compatible alias for [lightTheme].
ThemeData theme() => lightTheme();

/// Constructs and returns the application's Light Material 3 [ThemeData].
ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      error: AppColors.error,
      onError: AppColors.onError,
      outline: AppColors.outline,
    ),
    appBarTheme: _lightAppBarTheme(),
  );
}

/// Constructs and returns the application's Dark Material 3 [ThemeData].
ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkOnPrimaryContainer,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondaryContainer: AppColors.darkOnSecondaryContainer,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      surfaceContainerHighest: AppColors.darkSurfaceVariant,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      outline: AppColors.darkOutline,
    ),
    appBarTheme: _darkAppBarTheme(),
  );
}

/// Constructs the light [AppBarTheme] configuration.
AppBarTheme _lightAppBarTheme() {
  return const AppBarTheme(
    backgroundColor: AppColors.surface,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.primary),
    titleTextStyle: AppTypography.headlinesMedium,
  );
}

/// Constructs the dark [AppBarTheme] configuration.
AppBarTheme _darkAppBarTheme() {
  return AppBarTheme(
    backgroundColor: AppColors.darkSurface,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColors.darkPrimary),
    titleTextStyle: AppTypography.headlinesMedium.copyWith(
      color: AppColors.darkOnSurface,
    ),
  );
}
