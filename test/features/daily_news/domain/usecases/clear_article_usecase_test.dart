import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/clear_article_usecase.dart';

/// Mock implementation of [ArticleRepository] using [Mocktail].
class MockArticleRepository extends Mock implements ArticleRepository {}

/// Unit test suite for [ClearArticleUseCase].
void main() {
  late ClearArticleUseCase useCase;
  late MockArticleRepository mockArticleRepository;

  /// Sets up mock repository and instantiates [ClearArticleUseCase] before each test.
  setUp(() {
    mockArticleRepository = MockArticleRepository();
    useCase = ClearArticleUseCase(mockArticleRepository);
  });

  test(
    'should call [ArticleRepository.clearSavedArticles] and return [DataSuccess]',
    () async {
      // Arrange: Stub repository clearSavedArticles to return DataSuccess(null)
      when(
        () => mockArticleRepository.clearSavedArticles(),
      ).thenAnswer((_) async => const DataSuccess(null));

      // Act: Execute the use case
      final result = await useCase();

      // Assert: Verify success state and single repository invocation
      expect(result, isA<DataSuccess<void>>());
      verify(() => mockArticleRepository.clearSavedArticles()).called(1);
      verifyNoMoreInteractions(mockArticleRepository);
    },
  );
}
