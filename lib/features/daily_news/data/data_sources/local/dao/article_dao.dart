import 'package:drift/drift.dart';
import 'package:news_app_clean_architecture/core/database/app_database.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/tables/article_table.dart';

part 'article_dao.g.dart';

@DriftAccessor(tables: [ArticleTable])
class ArticleDao extends DatabaseAccessor<AppDatabase> with _$ArticleDaoMixin {
  ArticleDao(super.db);

  // Mengambil semua artikel yang tersimpan di lokal
  Future<List<ArticleTableData>> getSavedArticles() =>
      select(articleTable).get();

  // Menyimpan artikel baru
  Future<void> insertArticle(ArticleTableCompanion article) =>
      into(articleTable).insertOnConflictUpdate(article);

  // Menghapus artikel
  Future<void> deleteArticle(int id) =>
      (delete(articleTable)..where((tbl) => tbl.id.equals(id))).go();
}
