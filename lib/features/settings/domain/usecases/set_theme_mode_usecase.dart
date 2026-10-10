import 'package:news_app_clean_architecture/core/usecases/usecase.dart';
import 'package:news_app_clean_architecture/features/settings/domain/repositories/theme_repository.dart';

/// Use case responsible for persisting the theme mode preference.
class SetThemeModeUseCase implements UseCase<void, bool> {
  final ThemeRepository _themeRepository;

  SetThemeModeUseCase(this._themeRepository);

  @override
  Future<void> call({bool? params}) {
    return _themeRepository.setDarkMode(params ?? false);
  }
}
