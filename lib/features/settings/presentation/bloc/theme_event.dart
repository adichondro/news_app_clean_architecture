import 'package:equatable/equatable.dart';

/// Abstract base event for application theme operation.
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

/// Event dispatched when the application starts to retrieve saved theme preference.
class GetSavedTheme extends ThemeEvent {
  const GetSavedTheme();
}

/// Event dispatched when the user toggles between light and dark mode.
class ToggleTheme extends ThemeEvent {
  const ToggleTheme();
}

