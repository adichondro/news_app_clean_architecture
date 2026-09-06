import 'package:shared_preferences/shared_preferences.dart';

/// Contract for local theme persistence data operations.
abstract class ThemeLocalDataSource {
  Future<bool> isDarkMode();
  Future<void> setDarkMode(bool isDarkMode);
}

/// Implementation of [ThemeLocalDataSource] that uses SharedPreferences for local storage.
class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  static const String _kThemeModeKey = 'k_theme_mode_is_dark';
  final SharedPreferences _sharedPreferences;

  /// Creates a [ThemeLocalDataSourceImpl] with the given [_sharedPreferences].
  ThemeLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<bool> isDarkMode() async {
    return _sharedPreferences.getBool(_kThemeModeKey) ?? false;
  }

  @override
  Future<void> setDarkMode(bool isDark) async {
    await _sharedPreferences.setBool(_kThemeModeKey, isDark);
  }
}
