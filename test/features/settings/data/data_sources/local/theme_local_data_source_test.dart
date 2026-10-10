import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/features/settings/data/data_sources/local/theme_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock implementation of [SharedPreferences] using [Mocktail].
class MockSharedPreferences extends Mock implements SharedPreferences {}

/// Unit test suite for [ThemeLocalDataSourceImpl].
void main() {
  late ThemeLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  const tThemeModeKey = 'k_theme_mode_is_dark';

  /// Sets up dependencies and mock objects before each test execution.
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ThemeLocalDataSourceImpl(mockSharedPreferences);
  });

  group('isDarkMode', () {
    test(
      'should return true when storage contains true for theme key',
      () async {
        // Arrange: Stub getBool to return true
        when(
          () => mockSharedPreferences.getBool(tThemeModeKey),
        ).thenReturn(true);

        // Act: Execute isDarkMode
        final result = await dataSource.isDarkMode();

        // Assert: Verify return value and exact key lookup
        expect(result, isTrue);
        verify(() => mockSharedPreferences.getBool(tThemeModeKey)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );

    test(
      'should return false when storage contains false for theme key',
      () async {
        // Arrange: Stub getBool to return false
        when(
          () => mockSharedPreferences.getBool(tThemeModeKey),
        ).thenReturn(false);

        // Act: Execute isDarkMode
        final result = await dataSource.isDarkMode();

        // Assert: Verify return value and exact key lookup
        expect(result, isFalse);
        verify(() => mockSharedPreferences.getBool(tThemeModeKey)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );

    test(
      'should return false as safe default when theme key does not exist (first run)',
      () async {
        // Arrange: Stub getBool to return null (key not present yet)
        when(
          () => mockSharedPreferences.getBool(tThemeModeKey),
        ).thenReturn(null);

        // Act: Execute isDarkMode
        final result = await dataSource.isDarkMode();

        // Assert: Verify fallback to false
        expect(result, isFalse);
        verify(() => mockSharedPreferences.getBool(tThemeModeKey)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );

    test(
      'should rethrow exception when storage fails to read theme preference',
      () async {
        // Arrange: Stub getBool to throw an exception
        final tException = Exception('Failed to read theme mode');
        when(
          () => mockSharedPreferences.getBool(tThemeModeKey),
        ).thenThrow(tException);

        // Act: Define invocation
        final call = dataSource.isDarkMode;

        // Assert: Verify exception propagation
        expect(() => call(), throwsA(isA<Exception>()));
        verify(() => mockSharedPreferences.getBool(tThemeModeKey)).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
  });

  group('setDarkMode', () {
    test('should call SharedPreferences to persist dark mode (true)', () async {
      // Arrange: Stub setBool to complete successfully
      when(
        () => mockSharedPreferences.setBool(tThemeModeKey, true),
      ).thenAnswer((_) async => true);

      // Act: Execute setDarkMode with true
      await dataSource.setDarkMode(true);

      // Assert: Verify write interaction with exact key and value
      verify(
        () => mockSharedPreferences.setBool(tThemeModeKey, true),
      ).called(1);
      verifyNoMoreInteractions(mockSharedPreferences);
    });

    test(
      'should call SharedPreferences to persist light mode (false)',
      () async {
        // Arrange: Stub setBool to complete successfully
        when(
          () => mockSharedPreferences.setBool(tThemeModeKey, false),
        ).thenAnswer((_) async => true);

        // Act: Execute setDarkMode with false
        await dataSource.setDarkMode(false);

        // Assert: Verify write interaction with exact key and value
        verify(
          () => mockSharedPreferences.setBool(tThemeModeKey, false),
        ).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );

    test(
      'should rethrow exception when storage fails to persist theme preference',
      () async {
        // Arrange: Stub setBool to throw an exception
        final tException = Exception('Failed to save theme');
        when(
          () => mockSharedPreferences.setBool(tThemeModeKey, any()),
        ).thenThrow(tException);

        // Act: Define invocation
        final call = dataSource.setDarkMode;

        // Assert: Verify exception propagation
        expect(() => call(true), throwsA(isA<Exception>()));
        verify(
          () => mockSharedPreferences.setBool(tThemeModeKey, any()),
        ).called(1);
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );
  });
}
