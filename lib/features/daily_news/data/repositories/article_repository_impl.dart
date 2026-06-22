import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:news_app_clean_architecture/core/constant/query_constants.dart';
import 'package:news_app_clean_architecture/core/database/app_database.dart';
import 'package:news_app_clean_architecture/core/env/env.dart';
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
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: Env.apiKey,
        country: QueryConstants.country,
        category: QueryConstants.category,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(
          DioException(
            error: httpResponse.response,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<List<ArticleEntity>> getSavedArticles() async {
    final localData = await _articleDao.getSavedArticles();
    return localData.map((data) => ArticleModel.fromTableData(data)).toList();
  }

  @override
  Future<void> saveArticle(ArticleEntity article) async {
    final companion = ArticleTableCompanion(
      author: Value(article.author),
      title: Value(article.title),
      description: Value(article.description),
      url: Value(article.url),
      urlToImage: Value(article.urlToImage),
      publishedAt: Value(article.publishedAt),
      content: Value(article.content),
    );
    await _articleDao.insertArticle(companion);
  }

  @override
  Future<void> removeArticle(ArticleEntity article) async {

    if (article.id != null) {
      await _articleDao.deleteArticle(article.id!);
    }
  }
}
