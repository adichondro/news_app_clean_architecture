import 'package:equatable/equatable.dart';

/// State representing the application's active theme configuration.
class ThemeState extends Equatable {
  /// Flag indicating whether dark mode is currently active.
  final bool isDark;

  /// Crates a [ThemeState] with [isDark] defaulting to false (Light Mode).
  const ThemeState({this.isDark = false});

  /// Crates a copy of this state with optional updated attributes.
  ThemeState copyWith({bool? isDark}) {
    return ThemeState(isDark: isDark ?? this.isDark);
  }

  @override
  List<Object?> get props => [isDark];
}
