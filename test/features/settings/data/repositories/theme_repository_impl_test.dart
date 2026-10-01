import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/settings/data/data_sources/local/theme_local_data_source.dart';
import 'package:news_app_clean_architecture/features/settings/data/repositories/theme_repository_impl.dart';

/// Mock implementation of [ThemeLocalDataSource] using [Mocktail].
class MockThemeLocalDataSource extends Mock implements ThemeLocalDataSource {}

/// Unit test suite for [ThemeRepositoryImpl].
void main() {
  late ThemeRepositoryImpl repository;
  late MockThemeLocalDataSource mockThemeLocalDataSource;

  /// Sets up dependencies and mock objects before each test execution.
  setUp(() {
    mockThemeLocalDataSource = MockThemeLocalDataSource();
    repository = ThemeRepositoryImpl(mockThemeLocalDataSource);
  });

  group('isDarkMode', () {
    test('should return true when data source returns true', () async {
      // Arrange: Stub data source to return true
      when(
        () => mockThemeLocalDataSource.isDarkMode(),
      ).thenAnswer((_) async => true);

      // Act: Execute repository isDarkMode
      final result = await repository.isDarkMode();

      // Assert: Verify return value and delegation
      expect(result, isTrue);
      verify(() => mockThemeLocalDataSource.isDarkMode()).called(1);
      verifyNoMoreInteractions(mockThemeLocalDataSource);
    });

    test('should return false when data source returns false', () async {
      // Arrange: Stub data source to return false
      when(
        () => mockThemeLocalDataSource.isDarkMode(),
      ).thenAnswer((_) async => false);

      // Act: Execute repository isDarkMode
      final result = await repository.isDarkMode();

      // Assert: Verify return value and delegation
      expect(result, isFalse);
      verify(() => mockThemeLocalDataSource.isDarkMode()).called(1);
      verifyNoMoreInteractions(mockThemeLocalDataSource);
    });

    test(
      'should rethrow exception when data source fails to retrieve theme mode',
      () async {
        // Arrange: Stub data source to throw an exception
        final tException = Exception('Failed to read from local storage');
        when(() => mockThemeLocalDataSource.isDarkMode()).thenThrow(tException);

        // Act: Define invocation
        final call = repository.isDarkMode;

        // Assert: Verify exception propagation
        expect(() => call(), throwsA(isA<Exception>()));
        verify(() => mockThemeLocalDataSource.isDarkMode()).called(1);
        verifyNoMoreInteractions(mockThemeLocalDataSource);
      },
    );
  });

  group('setDarkMode', () {
    test(
      'should delegate to data source to persist dark mode (true)',
      () async {
        // Arrange: Stub data source to return void
        when(
          () => mockThemeLocalDataSource.setDarkMode(true),
        ).thenAnswer((_) async => {});

        // Act: Execute repository setDarkMode with true
        await repository.setDarkMode(true);

        // Assert: Verify delegation with exact boolean parameter
        verify(() => mockThemeLocalDataSource.setDarkMode(true)).called(1);
        verifyNoMoreInteractions(mockThemeLocalDataSource);
      },
    );

    test(
      'should delegate to data source to persist light mode (false)',
      () async {
        // Arrange: Stub data source to complete successfully
        when(
          () => mockThemeLocalDataSource.setDarkMode(false),
        ).thenAnswer((_) async => {});

        // Act: Execute repository setDarkMode with false
        await repository.setDarkMode(false);

        // Assert: Verify delegation with exact boolean parameter
        verify(() => mockThemeLocalDataSource.setDarkMode(false)).called(1);
        verifyNoMoreInteractions(mockThemeLocalDataSource);
      },
    );

    test(
      'should rethrow exception when data source fails to persist theme preference',
      () async {
        // Arrange: Stub data source to throw an exception
        final tException = Exception('Failed to write to local storage');
        when(
          () => mockThemeLocalDataSource.setDarkMode(any()),
        ).thenThrow(tException);

        // Act: Define invocation
        final call = repository.setDarkMode;

        // Assert: Verify exception propagation
        expect(() => call(true), throwsA(isA<Exception>()));
        verify(() => mockThemeLocalDataSource.setDarkMode(true)).called(1);
        verifyNoMoreInteractions(mockThemeLocalDataSource);
      },
    );
  });
}
