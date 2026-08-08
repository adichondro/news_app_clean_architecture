import 'package:news_app_clean_architecture/core/constant/query_constants.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/dao/article_dao.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_model.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_response_model.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repositories/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

/// Mock implementation using [Mocktail].
class MockNewsApiService extends Mock implements NewsApiService {}

class MockArticleDao extends Mock implements ArticleDao {}

/// Unit test suite for [ArticleRepositoryImpl].
void main() {
  late ArticleRepositoryImpl repository;
  late MockNewsApiService mockNewsApiService;
  late MockArticleDao mockArticleDao;

  setUpAll(() {
    registerFallbackValue(const ArticleModel());
  });

  setUp(() {
    mockNewsApiService = MockNewsApiService();
    mockArticleDao = MockArticleDao();
    repository = ArticleRepositoryImpl(mockNewsApiService, mockArticleDao);
  });

  const tArticleModel = ArticleModel(
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

  const tArticleEntity = ArticleEntity(
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

  group('getNewsArticles', () {
    test(
      'should return [DataSuccess] with List<ArticleEntity> when remote API call is successful',
      () async {
        const tResponse = ArticleResponseModel(
          status: 'ok',
          totalResults: 1,
          articles: [tArticleModel],
        );
        when(
          () => mockNewsApiService.getNewsArticles(
            country: QueryConstants.country,
            category: QueryConstants.category,
          ),
        ).thenAnswer((_) async => tResponse);

        // Act: Execute repository getNewsArticle
        final result = await repository.getNewsArticles();

        // Assert: verify mapping to entity and single API invocation
        expect(result, isA<DataSuccess<List<ArticleEntity>>>());
        expect(result.data, equals([tArticleEntity]));
        verify(
          () => mockNewsApiService.getNewsArticles(
            country: QueryConstants.country,
            category: QueryConstants.category,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockNewsApiService);
        verifyZeroInteractions(mockArticleDao);
      },
    );
  });

  group('getSavedArticles', () {
    test(
      'should return [DataSuccess] with List<ArticleEntity> from local DAO',
      () async {
        // Arrange: Stub ArticleDao to return local models
        when(
          () => mockArticleDao.getSavedArticles(),
        ).thenAnswer((_) async => [tArticleModel]);

        // Act: Execute repository getSavedArticles
        final result = await repository.getSavedArticles();

        // Assert: Verify mapping to entity and single DAO invocation
        expect(result, isA<DataSuccess<List<ArticleEntity>>>());
        expect(result.data, equals([tArticleEntity]));
        verify(() => mockArticleDao.getSavedArticles()).called(1);
        verifyNoMoreInteractions(mockArticleDao);
        verifyZeroInteractions(mockNewsApiService);
      },
    );
  });

  group('saveArticle', () {
    test(
      'should call [ArticleDao.insertArticle] and return [DataSuccess] with void payload',
      () async {
        // Arrange: Stub ArticleDao insertArticle to return void
        when(
          () => mockArticleDao.insertArticle(any()),
        ).thenAnswer((_) async => 1);

        // Act: Execute repository saveArticle
        final result = await repository.saveArticle(tArticleEntity);

        // Assert: verify success state and single DAO invocation
        expect(result, isA<DataSuccess<void>>());
        verify(() => mockArticleDao.insertArticle(any())).called(1);
        verifyNoMoreInteractions(mockArticleDao);
        verifyZeroInteractions(mockNewsApiService);
      },
    );
  });

  group('removeArticle', () {
    test(
      'should call [ArticleDao.deleteArticle] when article id is present',
      () async {
        // Arrange: Stub ArticleDao deleteArticle by id
        when(
          () => mockArticleDao.deleteArticle(tArticleEntity.id!),
        ).thenAnswer((_) async => 1);
        // Act: Execute repository removeArticle
        final result = await repository.removeArticle(tArticleEntity);
        // Assert: Verify success state and single DAO invocation by ID
        expect(result, isA<DataSuccess<void>>());
        verify(
          () => mockArticleDao.deleteArticle(tArticleEntity.id!),
        ).called(1);
        verifyNoMoreInteractions(mockArticleDao);
        verifyZeroInteractions(mockNewsApiService);
      },
    );
  });

  group('clearSavedArticles', () {
    test(
      'should call [ArticleDao.clearAllArticles] and return [DataSuccess]',
      () async {
        // Arrange: Stub ArticleDao clearAllArticles
        when(
          () => mockArticleDao.clearAllArticles(),
        ).thenAnswer((_) async => 1);
        // Act: Execute repository clearSavedArticles
        final result = await repository.clearSavedArticles();
        // Assert: Verify success state and single DAO invocation
        expect(result, isA<DataSuccess<void>>());
        verify(() => mockArticleDao.clearAllArticles()).called(1);
        verifyNoMoreInteractions(mockArticleDao);
        verifyZeroInteractions(mockNewsApiService);
      },
    );
  });
}
