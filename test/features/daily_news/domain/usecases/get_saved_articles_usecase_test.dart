import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_saved_articles_usecase.dart';

/// Mock implementation of [ArticleRepository] powered by [mocktail].
class MockArticleRepository extends Mock implements ArticleRepository {}

/// Unit test suite for [GetSavedArticlesUseCase].
void main() {
  late GetSavedArticlesUseCase useCase;
  late MockArticleRepository mockArticleRepository;

  /// Sets up mock repository and instantiates [GetSavedArticlesUseCase] before each test.
  setUp(() {
    mockArticleRepository = MockArticleRepository();
    useCase = GetSavedArticlesUseCase(mockArticleRepository);
  });

  /// Sample article entity list used as mock payload during test.
  const tArticles = [
    ArticleEntity(
      id: 1,
      author: 'John Doe',
      title: 'Article Title',
      description: 'Article Description',
      url: 'https://example.com',
      urlToImage: 'https://example.com/image.jpg',
      publishedAt: '2022-01-01T00:00:00Z',
      content: 'Article Content',
      sourceName: 'BBC News',
    ),
  ];

  test('should fetch saved articles from repository and return [DataSuccess]', () async {
    // Arrange: Stub repository getSavedArticles to return DataSuccess with articles.
    when(() => mockArticleRepository.getSavedArticles()).thenAnswer((_) async => const DataSuccess(tArticles));

    // Act: Call the use case
    final result = await useCase();

    // Assert: Verify state payload and single repository invocation
    expect(result, isA<DataSuccess<List<ArticleEntity>>>());
    expect(result.data, equals(tArticles));

    // Verify repository interactions
    verify(() => mockArticleRepository.getSavedArticles()).called(1);
    verifyNoMoreInteractions(mockArticleRepository);
  });
}
