import 'package:news_app_clean_architecture/core/usecases/usecase.dart';
import 'package:news_app_clean_architecture/features/settings/domain/repositories/theme_repository.dart';

/// Use case responsible for retrieving the theme mode preference.
class GetThemeModeUseCase implements UseCase<bool, void> {
  final ThemeRepository _themeRepository;

  GetThemeModeUseCase(this._themeRepository);

  @override
  Future<bool> call({void params}) {
    return _themeRepository.isDarkMode();
  }
}
