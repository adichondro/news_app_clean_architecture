import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/remove_article_usecase.dart';

/// Mock implementation of [ArticleRepository] powered by [Mocktail].
class MockArticleRepository extends Mock implements ArticleRepository {}

/// Unit test suite for [RemoveArticleUseCase].
void main() {
  late RemoveArticleUseCase useCase;
  late MockArticleRepository mockArticleRepository;

  /// Sets up mock repository and instantiates [RemoveArticleUseCase] before each test.
  setUp(() {
    mockArticleRepository = MockArticleRepository();
    useCase = RemoveArticleUseCase(mockArticleRepository);
  });

  /// Sample article entity used as target payload for remove operations.
  const tArticle = ArticleEntity(
    id: 1,
    author: 'John Doe',
    title: 'Article Title',
    description: 'Article Description',
    url: 'https://example.com',
    urlToImage: 'https://example.com/image.jpg',
    publishedAt: '2022-01-01T00:00:00Z',
    content: 'Article Content',
    sourceName: 'BBC News',
  );

  test(
    'should call [ArticleRepository.removeArticle] and return [DataSuccess] with void payload',
    () async {
      // Arrange: Stub repository removeArticle to return DataSuccess(null)
      when(
        () => mockArticleRepository.removeArticle(tArticle),
      ).thenAnswer((_) async => const DataSuccess(null));

      // Act: Call the use case with the target article
      final result = await useCase(params: tArticle);

      // Assert:
      expect(result, isA<DataSuccess<void>>());
      verify(() => mockArticleRepository.removeArticle(tArticle)).called(1);
      verifyNoMoreInteractions(mockArticleRepository);
    },
  );
}
