import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';

/// Abstract contract for managing remote news fetches and local article persistence.
abstract class ArticleRepository {
  /// Fetches top news headlines from the remote REST API service.
  Future<DataState<List<ArticleEntity>>> getNewsArticles();

  /// Retrieves all user-bookmarked news articles from local storage.
  Future<DataState<List<ArticleEntity>>> getSavedArticles();

  /// Saves a user-bookmarked [article] into local storage.
  Future<DataState<void>> saveArticle(ArticleEntity article);

  /// Removes a bookmarked [article] from local storage.
  Future<DataState<void>> removeArticle(ArticleEntity article);

  /// Clears all bookmarked articles from local storage.
  Future<DataState<void>> clearSavedArticles();
}

