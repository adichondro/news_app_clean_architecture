import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getNewsArticles();

  Future<DataState<List<ArticleEntity>>> getSavedArticles();

  Future<DataState<void>> saveArticle(ArticleEntity article);

  Future<DataState<void>> removeArticle(ArticleEntity article);

  Future<DataState<void>> clearSavedArticles();
}
