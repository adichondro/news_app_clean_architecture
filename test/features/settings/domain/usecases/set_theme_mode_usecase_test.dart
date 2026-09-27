import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/settings/domain/repositories/theme_repository.dart';
import 'package:news_app_clean_architecture/features/settings/domain/usecases/set_theme_mode_usecase.dart';

/// Mock implementation of [ThemeRepository] using Mocktail library.
class MockThemeRepository extends Mock implements ThemeRepository {}

/// Unit test suite for [SetThemeModeUseCase].
void main() {
  late SetThemeModeUseCase useCase;
  late MockThemeRepository mockThemeRepository;

  /// Sets up dependencies and mock objects before each test execution.
  setUp(() {
    mockThemeRepository = MockThemeRepository();
    useCase = SetThemeModeUseCase(mockThemeRepository);
  });

  group('SetThemeModeUseCase', () {
    test(
      'should call repository to persist dark mode when params is true',
      () async {
        // Arrange: Stub repository setDarkMode to complete successfully
        when(
          () => mockThemeRepository.setDarkMode(true),
        ).thenAnswer((_) async {});

        // Act: Execute usecase with dark mode enabled
        await useCase(params: true);

        // Assert: Verify repository was invoked with true
        verify(() => mockThemeRepository.setDarkMode(true)).called(1);
        verifyNoMoreInteractions(mockThemeRepository);
      },
    );

    test(
      'should call repository to persist light mode when params is false',
      () async {
        // Arrange: Stub repository setDarkMode to complete successfully
        when(
          () => mockThemeRepository.setDarkMode(false),
        ).thenAnswer((_) async => {});

        // Act: Execute usecase with light mode
        await useCase(params: false);

        // Assert: Verify repository was invoked with false
        verify(() => mockThemeRepository.setDarkMode(false)).called(1);
        verifyNoMoreInteractions(mockThemeRepository);
      },
    );

    test(
      'should fallback to false and call repository when params is null',
      () async {
        // Arrange: Stub repository setDarkMode to complete successfully
        when(
          () => mockThemeRepository.setDarkMode(false),
        ).thenAnswer((_) async {});

        // Act: Execute usecase without params or with null
        await useCase();

        // Assert: Verify repository was invoked with false as safe fallback
        verify(() => mockThemeRepository.setDarkMode(false)).called(1);
        verifyNoMoreInteractions(mockThemeRepository);
      },
    );

    test(
      'should rethrow exception when repository call fails to persist theme',
      () async {
        // Arrange: Stub repository to throw an exception
        final tException = Exception(
          'Failed to write theme preference to storage',
        );
        when(
          () => mockThemeRepository.setDarkMode(any()),
        ).thenThrow(tException);

        // Act: Define the invocation
        final call = useCase;

        // Assert: Verify that use case propagates the exception and interactions
        expect(() => call(params: true), throwsA(isA<Exception>()));
        verify(() => mockThemeRepository.setDarkMode(true)).called(1);
        verifyNoMoreInteractions(mockThemeRepository);
      },
    );
  });
}
