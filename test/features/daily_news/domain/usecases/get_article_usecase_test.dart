import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article_usecase.dart';

/// Mock implementation of [ArticleRepository] powered by [Mocktail].
class MockArticleRepository extends Mock implements ArticleRepository {}

/// Unit test suite for [GetArticleUseCase].
void main() {
  late GetArticleUseCase useCase;
  late MockArticleRepository mockArticleRepository;

  /// Sets up dependencies and mock objects before each test execution.
  setUp(() {
    mockArticleRepository = MockArticleRepository();
    useCase = GetArticleUseCase(mockArticleRepository);
  });

  /// Sample article entity used as mock payload during tests.
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
    ),
  ];

  test(
    'should fetch aericles from repositoiry anda return [DataSuccess]',
    () async {
      //Arrange: Define mock behavior to return success payload
      when(
        () => mockArticleRepository.getNewsArticles(),
      ).thenAnswer((_) async => const DataSuccess(tArticles));

      // act: Triger the use case call
      final result = await useCase();

      //assert: cerify state payload and repository interactions
      expect(result, isA<DataSuccess<List<ArticleEntity>>>());
      expect(result.data, equals(tArticles));

      // Verify that the repository method is called exactly once
      verify(() => mockArticleRepository.getNewsArticles()).called(1);
      verifyNoMoreInteractions(mockArticleRepository);
    },
  );
}
