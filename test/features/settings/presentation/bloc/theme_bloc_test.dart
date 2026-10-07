import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:news_app_clean_architecture/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:news_app_clean_architecture/features/settings/presentation/bloc/theme_bloc.dart';
import 'package:news_app_clean_architecture/features/settings/presentation/bloc/theme_event.dart';
import 'package:news_app_clean_architecture/features/settings/presentation/bloc/theme_state.dart';

/// Mock implementation of [GetThemeModeUseCase] using [Mocktail].
class MockGetThemeModeUseCase extends Mock implements GetThemeModeUseCase {}

/// Mock implementation of [SetThemeModeUseCase] using [Mocktail].
class MockSetThemeModeUseCase extends Mock implements SetThemeModeUseCase {}

/// Unit test suite for [ThemeBloc].
void main() {
  late ThemeBloc themeBloc;
  late MockGetThemeModeUseCase mockGetThemeModeUseCase;
  late MockSetThemeModeUseCase mockSetThemeModeUseCase;

  /// Sets up dependencies and mock objects before each test execution.
  setUp(() {
    mockGetThemeModeUseCase = MockGetThemeModeUseCase();
    mockSetThemeModeUseCase = MockSetThemeModeUseCase();
    themeBloc = ThemeBloc(mockGetThemeModeUseCase, mockSetThemeModeUseCase);
  });

  /// Cleans up resources and mock objects after each test execution.
  tearDown(() {
    themeBloc.close();
  });

  test('initial state should be [ThemeState] with isDark set to false', () {
    // Assert: Verify default state
    expect(themeBloc.state, const ThemeState(isDark: false));
  });

  group('GetSavedTheme', () {
    blocTest<ThemeBloc, ThemeState>(
      'should emit [ThemeState(isDark: true)] when saved theme preference is dark mode',
      build: () {
        // Arrange: Stub usecase to return true
        when(() => mockGetThemeModeUseCase()).thenAnswer((_) async => true);
        return themeBloc;
      },
      act: (bloc) => bloc.add(const GetSavedTheme()),
      expect: () => [
        // Assert: Expect state transition to dark mode
        const ThemeState(isDark: true),
      ],
      verify: (_) {
        verify(() => mockGetThemeModeUseCase()).called(1);
        verifyZeroInteractions(mockSetThemeModeUseCase);
      },
    );
    blocTest<ThemeBloc, ThemeState>(
      'should emit [ThemeState(isDark: false)] when current state is dark and saved theme is light mode',
      seed: () => const ThemeState(isDark: true),
      build: () {
        // Arrange: Stub usecase to return false
        when(() => mockGetThemeModeUseCase()).thenAnswer((_) async => false);
        return themeBloc;
      },
      act: (bloc) => bloc.add(const GetSavedTheme()),
      expect: () => [
        // Assert: Expect state transition to light mode
        const ThemeState(isDark: false),
      ],
      verify: (_) {
        verify(() => mockGetThemeModeUseCase()).called(1);
        verifyZeroInteractions(mockSetThemeModeUseCase);
      },
    );

    blocTest<ThemeBloc, ThemeState>(
      'should retain current state and not emit when GetThemeModeUseCase throws an exception',
      build: () {
        // Arrange: Stub usecase to throw an exception
        when(
          () => mockGetThemeModeUseCase(),
        ).thenThrow(Exception('Failed to read theme from storage'));
        return themeBloc;
      },
      act: (bloc) => bloc.add(const GetSavedTheme()),
      // Assert: No state emitted because exception was caught defensively
      expect: () => [],
      verify: (_) {
        verify(() => mockGetThemeModeUseCase()).called(1);
        verifyZeroInteractions(mockSetThemeModeUseCase);
      },
    );
  });

  group('ToggleTheme', () {
    blocTest<ThemeBloc, ThemeState>(
      'should toggle theme from light to dark and call SetThemeModeUseCase with true',
      build: () {
        // Arrange: Stub usecase to complete successfully
        when(
          () => mockSetThemeModeUseCase(params: true),
        ).thenAnswer((_) async {});
        return themeBloc;
      },
      act: (bloc) => bloc.add(const ToggleTheme()),
      expect: () => [
        // Assert: Expect transition from false to true
        const ThemeState(isDark: true),
      ],
      verify: (_) {
        verify(() => mockSetThemeModeUseCase(params: true)).called(1);
        verifyZeroInteractions(mockGetThemeModeUseCase);
      },
    );

    blocTest<ThemeBloc, ThemeState>(
      'should toggle theme from dark to light and call SetThemeModeUseCase with false',
      seed: () => const ThemeState(isDark: true),
      build: () {
        // Arrange: Stub usecase to complete successfully
        when(
          () => mockSetThemeModeUseCase(params: false),
        ).thenAnswer((_) async {});
        return themeBloc;
      },
      act: (bloc) => bloc.add(const ToggleTheme()),
      expect: () => [
        // Assert: Expect transition from true to false
        const ThemeState(isDark: false),
      ],
      verify: (_) {
        verify(() => mockSetThemeModeUseCase(params: false)).called(1);
        verifyZeroInteractions(mockGetThemeModeUseCase);
      },
    );

    blocTest<ThemeBloc, ThemeState>(
      'should retain current state and not emit when SetThemeModeUseCase throws an exception',
      build: () {
        // Arrange: Stub usecase to throw exception
        when(
          () => mockSetThemeModeUseCase(params: true),
        ).thenThrow(Exception('Failed to save theme to storage'));
        return themeBloc;
      },
      act: (bloc) => bloc.add(const ToggleTheme()),
      // Assert: No new state emitted, preventing UI desynchronization
      expect: () => [],
      verify: (_) {
        verify(() => mockSetThemeModeUseCase(params: true)).called(1);
        verifyZeroInteractions(mockGetThemeModeUseCase);
      },
    );
  });
}
