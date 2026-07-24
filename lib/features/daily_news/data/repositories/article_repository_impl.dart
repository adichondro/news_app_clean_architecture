import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constant/query_constants.dart';
import 'package:news_app_clean_architecture/core/env/env.dart';
import 'package:news_app_clean_architecture/core/error/exception_handler.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/dao/article_dao.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_model.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article_entity.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final ArticleDao _articleDao;

  ArticleRepositoryImpl(this._newsApiService, this._articleDao);

  @override
  Future<DataState<List<ArticleEntity>>> getNewsArticles() async {
    try {
      final responseModel = await _newsApiService.getNewsArticles(
        apiKey: Env.apiKey,
        country: QueryConstants.country,
        category: QueryConstants.category,
      );
      final articleList = responseModel.articles ?? [];
      final List<ArticleEntity> articleEntities =
          articleList.map((model) => model.toEntity()).toList();
      return DataSuccess(articleEntities);
    } on DioException catch (e) {
      return DataFailed(ExceptionHandler.handleDioException(e));
    } catch (e) {
      return DataFailed(ServerFailure(e.toString()));
    }
  }

  @override
  Future<DataState<List<ArticleEntity>>> getSavedArticles() async {
    try {
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
      await _articleDao.clearAllArticles();
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(
        CacheFailure('Failed to clear saved articles: ${e.toString()}'),
      );
    }
  }
}
