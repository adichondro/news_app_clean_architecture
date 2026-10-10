import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:news_app_clean_architecture/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:news_app_clean_architecture/features/settings/presentation/bloc/theme_event.dart';
import 'package:news_app_clean_architecture/features/settings/presentation/bloc/theme_state.dart';

/// Bloc responsible for orchestrating application theme state and persistence.
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SetThemeModeUseCase _setThemeModeUseCase;

  ThemeBloc(this._getThemeModeUseCase, this._setThemeModeUseCase)
    : super(const ThemeState(isDark: false)) {
    on<GetSavedTheme>(_onGetSavedTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  /// Handles loading saved theme mode from storage.
  Future<void> _onGetSavedTheme(
    GetSavedTheme event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final isDark = await _getThemeModeUseCase();
      emit(ThemeState(isDark: isDark));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  /// Handles toggling theme mode and persisting the new preference.
  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final nextIsDark = !state.isDark;
      await _setThemeModeUseCase(params: nextIsDark);
      emit(ThemeState(isDark: nextIsDark));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}
