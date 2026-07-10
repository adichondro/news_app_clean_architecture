import 'package:drift/drift.dart';
import 'package:news_app_clean_architecture/core/database/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/tables/article_table.dart';

part 'article_dao.g.dart';

@DriftAccessor(tables: [ArticleTable])
class ArticleDao extends DatabaseAccessor<AppDatabase> with _$ArticleDaoMixin {
  ArticleDao(super.db);

  // Get all saved articles from local database
  Future<List<ArticleTableData>> getSavedArticles() =>
      select(articleTable).get();

  // 1. Insert article (with duplicate prevention)
  Future<void> insertArticle(ArticleTableCompanion article) async {
    final existingArticle =
        await (select(articleTable)
              ..where((tbl) => tbl.url.equals(article.url.value ?? '')))
            .getSingleOrNull();
    if (existingArticle != null) return;

    await into(articleTable).insert(article);
  }

  // 2. Delete article by ID (used by Saved Articles page)
  Future<void> deleteArticle(int id) =>
      (delete(articleTable)..where((tbl) => tbl.id.equals(id))).go();

  // 3. Delete article by URL (used by Daily News / Home page)
  Future<void> deleteArticleByUrl(String url) =>
      (delete(articleTable)..where((tbl) => tbl.url.equals(url))).go();
}
