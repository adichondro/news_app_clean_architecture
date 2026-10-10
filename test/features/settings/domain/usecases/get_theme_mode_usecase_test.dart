import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/settings/domain/repositories/theme_repository.dart';
import 'package:news_app_clean_architecture/features/settings/domain/usecases/get_theme_mode_usecase.dart';

/// Mock implementation of [ThemeRepository] using Mocktail library.
class MockThemeRepository extends Mock implements ThemeRepository {}

/// Unit test suite for [GetThemeModeUseCase].
void main() {
  late GetThemeModeUseCase useCase;
  late MockThemeRepository mockThemeRepository;

  /// Sets up dependencies and mock object before each test execution.
  setUp(() {
    mockThemeRepository = MockThemeRepository();
    useCase = GetThemeModeUseCase(mockThemeRepository);
  });

  group('GetThemeModeUseCase', () {
    test(
      'should return true when dark mode is enabled in the repository',
      () async {
        // Arrange: Stub repository to return true (Dark Mode)
        when(
          () => mockThemeRepository.isDarkMode(),
        ).thenAnswer((_) async => true);

        // Act: Execute the use case
        final result = await useCase();

        // Assert: Verify return value and repository interaction
        expect(result, isTrue);
        verify(() => mockThemeRepository.isDarkMode()).called(1);
        verifyNoMoreInteractions(mockThemeRepository);
      },
    );

    test(
      'should return false when light mode is enabled in the repository',
      () async {
        // Arrange: stub repository to return false (Light Mode)
        when(
          () => mockThemeRepository.isDarkMode(),
        ).thenAnswer((_) async => false);

        // Act: execute the use case
        final result = await useCase();

        // Assert: Verify return value and repository interaction
        expect(result, isFalse);
        verify(() => mockThemeRepository.isDarkMode()).called(1);
        verifyNoMoreInteractions(mockThemeRepository);
      },
    );

    test('should rethrow exception when repository call fails', () async {
      // Arrange: stub repository to throw an exception
      final tException = Exception(
        'Failed to retrieve theme mode from storage',
      );
      when(() => mockThemeRepository.isDarkMode()).thenThrow(tException);

      // Act: Define the invocation
      final call = useCase;

      // Assert: Verify that use case propagates the exception and interaction
      expect(() => call(), throwsA(isA<Exception>()));
      verify(() => mockThemeRepository.isDarkMode()).called(1);
      verifyNoMoreInteractions(mockThemeRepository);
    });
  });
}
