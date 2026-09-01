import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/core/database/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/dao/article_dao.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_model.dart';

/// Integration test suite for [ArticleDao] executed against an in-memory SQLite database.
///
/// Verifies raw CRUD operations, duplicate prevention, and schema constraints.
void main() {
  late AppDatabase database;
  late ArticleDao articleDao;

  /// Sets up an ephemeral in-memory database instance before each test.
  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    articleDao = database.articleDao;
  });

  /// Closes database connection after each test execution to free memory.
  tearDown(() async {
    await database.close();
  });

  const tArticle1 = ArticleModel(
    author: 'Author 1',
    title: 'Title 1',
    description: 'Description 1',
    url: 'https://example.com/1',
    urlToImage: 'https://example.com/image1.jpg',
    content: 'Content 1',
    publishedAt: '2023-01-01T00:00:00Z',
    sourceName: 'Source 1',
  );

  const tArticle2 = ArticleModel(
    author: 'Author 2',
    title: 'Title 2',
    description: 'Description 2',
    url: 'https://example.com/2',
    urlToImage: 'https://example.com/image2.jpg',
    content: 'Content 2',
    publishedAt: '2023-01-02T00:00:00Z',
    sourceName: 'Source 2',
  );

  group('ArticleDao SQLite In-Memory CRUD Tests', () {
    test('should return empty list when database is initially empty', () async {
      // Act: Fetch saved articles from empty table
      final result = await articleDao.getSavedArticles();

      // Assert: Verify empty list
      expect(result, isEmpty);
    });

    test('should insert and retrieve saved articles from database', () async {
      // Act: Insert article into database
      await articleDao.insertArticle(tArticle1);

      // Act: Query saved articles
      final result = await articleDao.getSavedArticles();

      // Assert: Verify article was stored and mapped correctly
      expect(result.length, equals(1));
      expect(result.first.title, equals(tArticle1.title));
      expect(result.first.url, equals(tArticle1.url));
      expect(result.first.id, isNotNull);
      expect(result.first.sourceName, equals(tArticle1.sourceName));
    });

    test(
      'should prevent duplicate article insertion when article with same url already exists',
      () async {
        // Arrange: Insert same article twice
        await articleDao.insertArticle(tArticle1);
        await articleDao.insertArticle(tArticle1);

        // Act: Query saved articles
        final result = await articleDao.getSavedArticles();

        // Assert: Verify only single entry exists (duplicate guard active)
        expect(result.length, equals(1));
      },
    );

    test('should delete saved article by its primary key ID', () async {
      // Arrange: Insert two articles
      await articleDao.insertArticle(tArticle1);
      await articleDao.insertArticle(tArticle2);

      final initialList = await articleDao.getSavedArticles();
      expect(initialList.length, equals(2));

      final firstArticleID = initialList.first.id!;

      // Act: Delete first article by ID
      await articleDao.deleteArticle(firstArticleID);

      // Assert: Verify only second article remains in database
      final updatedList = await articleDao.getSavedArticles();
      expect(updatedList.length, equals(1));
      expect(updatedList.first.url, equals(tArticle2.url));
    });

    test('should delete saved article by its URL', () async {
      // Arrange: Insert two articles
      await articleDao.insertArticle(tArticle1);
      await articleDao.insertArticle(tArticle2);

      // Act: Delete article matching URL
      await articleDao.deleteArticleByUrl(tArticle1.url!);

      // Assert: Verify only second article remains
      final updatedList = await articleDao.getSavedArticles();
      expect(updatedList.length, equals(1));
      expect(updatedList.first.url, equals(tArticle2.url));
    });
    test('should clear all records when clearAllArticles is called', () async {
      // Arrange: Insert two articles
      await articleDao.insertArticle(tArticle1);
      await articleDao.insertArticle(tArticle2);

      // Act: Clear all articles
      await articleDao.clearAllArticles();

      // Assert: Verify table is completely empty
      final result = await articleDao.getSavedArticles();
      expect(result, isEmpty);
    });
  });
}
