import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constant/api_constants.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'news_api_service.g.dart';

/// Retrofit REST API service client for fetching news headlines.
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class NewsApiService {
  /// Factory constructor backed by Retrofit code generation.
  factory NewsApiService(Dio dio) = _NewsApiService;

  /// Requests top headline news articles filtering by optional [country] and [category].
  @GET('/top-headlines')
  Future<ArticleResponseModel> getNewsArticles({ 
    @Query("country") String? country,
    @Query("category") String? category,
  });
}

