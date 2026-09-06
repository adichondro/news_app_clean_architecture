/// Contract defining theme persistence operations.
abstract class ThemeRepository {
  /// Retrieves the stored theme mode preference.
  /// Returns 'true' if dark mode is enabled, 'false' otherwise.
  Future<bool> isDarkMode();

  /// Persists the theme mode preference.
  /// 'isDarkMode' must be 'true' for dark mode and 'false' for light mode.
  Future<void> setDarkMode(bool isDarkMode);
}
