import 'package:drift/drift.dart';
import 'package:news_app_clean_architecture/core/database/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/tables/article_table.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_model.dart';

part 'article_dao.g.dart';

/// Data Access Object (DAO) executing CRUD database queries on [ArticleTable].
@DriftAccessor(tables: [ArticleTable])
class ArticleDao extends DatabaseAccessor<AppDatabase> with _$ArticleDaoMixin {
  /// Creates an [ArticleDao] accessor using the given [db] database instance.
  ArticleDao(super.db);

  /// Retrieves all saved articles from local SQLite storage.
  Future<List<ArticleModel>> getSavedArticles() async {
    final result = await select(articleTable).get();
    return result.map((data) => ArticleModel.fromTableData(data)).toList();
  }

  /// Inserts a new article into local storage with duplicate prevention by URL.
  Future<void> insertArticle(ArticleModel article) async {
    // Check if article with matching URL already exists in database
    final existingArticle = await (select(
      articleTable,
    )..where((tbl) => tbl.url.equals(article.url ?? ''))).getSingleOrNull();

    if (existingArticle != null) return;

    final companion = ArticleTableCompanion(
      author: Value(article.author),
      title: Value(article.title),
      description: Value(article.description),
      url: Value(article.url),
      urlToImage: Value(article.urlToImage),
      publishedAt: Value(article.publishedAt),
      content: Value(article.content),
    );

    await into(articleTable).insert(companion);
  }

  /// Deletes a saved article from local storage by its unique primary key [id].
  Future<void> deleteArticle(int id) =>
      (delete(articleTable)..where((tbl) => tbl.id.equals(id))).go();

  /// Deletes a saved article from local storage by its source [url].
  Future<void> deleteArticleByUrl(String url) =>
      (delete(articleTable)..where((tbl) => tbl.url.equals(url))).go();

  /// Deletes all saved articles from local storage.
  Future<void> clearAllArticles() => delete(articleTable).go();
}

