import 'package:news_app_clean_architecture/core/constant/query_constants.dart';
import 'package:news_app_clean_architecture/core/error/exception_handler.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/dao/article_dao.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_model.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

/// Concrete implementation of [ArticleRepository] handling remote REST fetching and SQLite caching.
class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final ArticleDao _articleDao;

  /// Creates an [ArticleRepositoryImpl] instance with [_newsApiService] and [_articleDao].
  ArticleRepositoryImpl(this._newsApiService, this._articleDao);

  @override
  Future<DataState<List<ArticleEntity>>> getNewsArticles() async {
    try {
      // Fetch news headlines from remote REST API
      final responseModel = await _newsApiService.getNewsArticles(
        country: QueryConstants.country,
        category: QueryConstants.category,
      );
      final articleList = responseModel.articles ?? [];
      final List<ArticleEntity> articleEntities =
          articleList.map((model) => model.toEntity()).toList();
      return DataSuccess(articleEntities);
    } catch (e) {
      // Delegate raw exception to ExceptionHandler
      return DataFailed(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<DataState<List<ArticleEntity>>> getSavedArticles() async {
    try {
      // Retrieve bookmarked articles from local database
      final List<ArticleModel> localData = await _articleDao.getSavedArticles();
      final List<ArticleEntity> articleEntities =
          localData.map((model) => model.toEntity()).toList();
      return DataSuccess(articleEntities);
    } catch (e) {
      return DataFailed(
        CacheFailure('Failed to load local database: ${e.toString()}'),
      );
    }
  }

  @override
  Future<DataState<void>> saveArticle(ArticleEntity article) async {
    try {
      // Convert domain entity to DTO model and insert into SQLite
      final articleModel = ArticleModel.fromEntity(article);
      await _articleDao.insertArticle(articleModel);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(
        CacheFailure('Failed to save article to local storage: ${e.toString()}'),
      );
    }
  }

  @override
  Future<DataState<void>> removeArticle(ArticleEntity article) async {
    try {
      // Delete article from SQLite matching either primary key id or web url
      if (article.id != null) {
        await _articleDao.deleteArticle(article.id!);
      } else if (article.url != null) {
        await _articleDao.deleteArticleByUrl(article.url!);
      }
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(
        CacheFailure('Failed to remove article from local storage: ${e.toString()}'),
      );
    }
  }

  @override
  Future<DataState<void>> clearSavedArticles() async {
    try {
      // Delete all records from ArticleTable
      await _articleDao.clearAllArticles();
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(
        CacheFailure('Failed to clear saved articles: ${e.toString()}'),
      );
    }
  }
}
