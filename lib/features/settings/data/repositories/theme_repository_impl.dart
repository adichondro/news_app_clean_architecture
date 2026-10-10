import 'package:news_app_clean_architecture/features/settings/data/data_sources/local/theme_local_data_source.dart';
import 'package:news_app_clean_architecture/features/settings/domain/repositories/theme_repository.dart';

/// Concrete implementation of [ThemeRepository] coordinating with [ThemeLocalDataSource].
class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource _themeLocalDataSource;

  /// Creates a [ThemeRepositoryImpl] with the provided [_themeLocalDataSource].
  ThemeRepositoryImpl(this._themeLocalDataSource);

  @override
  Future<bool> isDarkMode() {
    return _themeLocalDataSource.isDarkMode();
  }

  @override
  Future<void> setDarkMode(bool isDark) {
    return _themeLocalDataSource.setDarkMode(isDark);
  }
}
