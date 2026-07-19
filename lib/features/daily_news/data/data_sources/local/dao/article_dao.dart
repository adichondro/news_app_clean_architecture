import 'package:drift/drift.dart';
import 'package:news_app_clean_architecture/core/database/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/tables/article_table.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_model.dart';

part 'article_dao.g.dart';

@DriftAccessor(tables: [ArticleTable])
class ArticleDao extends DatabaseAccessor<AppDatabase> with _$ArticleDaoMixin {
  ArticleDao(super.db);

  // Get all saved articles from local database
  Future<List<ArticleTableData>> getSavedArticles() =>
      select(articleTable).get();

  // 1. Insert article (with duplicate prevention)
  Future<void> insertArticle(ArticleModel article) async {
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
      content: Value(article.content)
    );

    await into(articleTable).insert(companion);
  }

  // 2. Delete article by ID (used by Saved Articles page)
  Future<void> deleteArticle(int id) =>
      (delete(articleTable)..where((tbl) => tbl.id.equals(id))).go();

  // 3. Delete article by URL (used by Daily News / Home page)
  Future<void> deleteArticleByUrl(String url) =>
      (delete(articleTable)..where((tbl) => tbl.url.equals(url))).go();

  // 4. Clear all articles
  Future<void> clearAllArticles() => delete(articleTable).go();
}
