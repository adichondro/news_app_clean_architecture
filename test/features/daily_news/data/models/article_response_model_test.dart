import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_model.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_response_model.dart';

/// Unit test suite for [ArticleResponseModel] JSON deserialization.
void main() {
  group('fromJson', () {
    test(
      'should return a valid [ArticleResponseModel] when parsing complete JSON response',
      () async {
        /// Arrange: Mock JSON response payload from NewsAPI
        final Map<String, dynamic> jsonMap = {
          'status': 'ok',
          'totalResults': 1,
          'articles': [
            {
              'source': {'id': null, 'name': 'BBC News'},
              'author': 'John Doe',
              'title': 'Article Title',
              'description': 'Article Description',
              'url': 'https://example.com',
              'urlToImage': 'https://example.com/image.jpg',
              'publishedAt': '2022-01-01T00:00:00Z',
              'content': 'Article Content',
            },
          ],
        };

        // Act: Deserialization JSON map
        final result = ArticleResponseModel.fromJson(jsonMap);

        // Assert: Verify mapped properties
        expect(result.status, equals('ok'));
        expect(result.totalResults, equals(1));
        expect(result.articles, isA<List<ArticleModel>>());
        expect(result.articles?.length, equals(1));
        expect(result.articles?.first.title, equals('Article Title'));
        expect(result.articles?.first.sourceName, equals('BBC News'));
      },
    );

    test('should return [ArticleResponseModel] with null articles when JSON articles is null', () async {
      // Arrange: Mock JSON with null articles.
      final Map<String, dynamic> jsonMap = {
        'status': 'ok',
        'totalResults': 0,
        'articles': null,
      };

      // Act: Deserialization JSON map
      final result = ArticleResponseModel.fromJson(jsonMap);

      // Assert: Verify mapped properties
      expect(result.status, equals('ok'));
      expect(result.totalResults, equals(0));
      expect(result.articles, isNull);
    });
  });
}
