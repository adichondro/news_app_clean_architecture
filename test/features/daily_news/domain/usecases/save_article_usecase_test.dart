
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/save_article_usecase.dart';

/// Mock implementation of [ArticleRepository] powered by [Mocktail].
class MockArticleRepository extends Mock implements ArticleRepository {}

/// Unit test suite for [SaveArticleUseCase].
void main() {
  late SaveArticleUseCase useCase;
  late MockArticleRepository mockArticleRepository;

  /// Sets up mock repository and instantiatee [SaveArticleUseCase] before each test.
  setUp(() {
    mockArticleRepository = MockArticleRepository();
    useCase = SaveArticleUseCase(mockArticleRepository);
  });

  /// Sample article entitu used as target pasyload for save operation.
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

  test('Should call  [ArticleRepository.saveArticle] and return [DataSuccess] with void payload', () async {
    // Arrange:  Stub repository saveArticle to return DataSuccess(null)
    when(() => mockArticleRepository.saveArticle(tArticle))
        .thenAnswer((_) async => const DataSuccess(null));
    
    // Act: Execute the use case with target article parameter
    final result = await useCase(params: tArticle);

    // Assert: Verify success state and single repository invocation
    expect(result, isA<DataSuccess<void>>());
    verify(() => mockArticleRepository.saveArticle(tArticle)).called(1);
    verifyNoMoreInteractions(mockArticleRepository);
  });
}