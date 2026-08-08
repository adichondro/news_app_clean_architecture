import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_model.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

/// Unit test suite for [ArticleModel] data mapping methods
void main() {
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

  group('fromJson', () {
    test(
      'should return a valid [ArticleModel] when JSON map is parsed',
      () async {
        // Arrange: Sample JSON response from NewsAPI
        final Map<String, dynamic> jsonMap = {
          'source': {'id': 'bbc-news', 'name': 'BBC News'},
          'author': 'John Doe',
          'title': 'Article Title',
          'description': 'Article Description',
          'url': 'https://example.com',
          'urlToImage': 'https://example.com/image.jpg',
          'publishedAt': '2022-01-01T00:00:00Z',
          'content': 'Article Content',
        };

        // Act: Parse JSON map into ArticleModel
        final result = ArticleModel.fromJson(jsonMap);

        // Assert: Verify mapping of json fields to model properties
        expect(result.title, equals(tArticleModel.title));
        expect(result.description, equals(tArticleModel.description));
        expect(result.sourceName, equals(tArticleModel.sourceName));
        expect(result.author, equals(tArticleModel.author));
        expect(result.publishedAt, equals(tArticleModel.publishedAt));
        expect(result.content, equals(tArticleModel.content));
        expect(result.urlToImage, equals(tArticleModel.urlToImage));
        expect(result.url, equals(tArticleModel.url));
      },
    );
  });

  group('toEntity', () {
    test(
      'should return a matching [ArticleEntity] payload from [ArticleModel]',
      () async {
        // Act: Convert model to domain entity
        final result = tArticleModel.toEntity();

        // Assert: Verify mapped properties match entity
        expect(result, isA<ArticleEntity>());
        expect(result.title, equals(tArticleEntity.title));
        expect(result.sourceName, equals(tArticleEntity.sourceName));
        expect(result.author, equals(tArticleEntity.author));
        expect(result.url, equals(tArticleEntity.url));
      },
    );
  });

  group('fromEntity', () {
    test(
      'should return a matching [ArticleModel] payload from [ArticleEntity]',
      () async {
        // Act: Convert entity to model
        final result = ArticleModel.fromEntity(tArticleEntity);

        // Assert: Verify the model properties match the entity
        expect(result.title, equals(tArticleModel.title));
        expect(result.sourceName, equals(tArticleModel.sourceName));
        expect(result.url, equals(tArticleModel.url));
        expect(result.urlToImage, equals(tArticleModel.urlToImage));
        expect(result.publishedAt, equals(tArticleModel.publishedAt));
        expect(result.content, equals(tArticleModel.content));
        expect(result.author, equals(tArticleModel.author));
      },
    );
  });
}
