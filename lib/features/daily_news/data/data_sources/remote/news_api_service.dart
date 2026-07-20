import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constant/api_constants.dart';

import 'package:news_app_clean_architecture/features/daily_news/data/models/article_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'news_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class NewsApiService {
  factory NewsApiService(Dio dio) = _NewsApiService;

  @GET('/top-headlines')
  Future<ArticleResponseModel> getNewsArticles({ 
    @Query("apiKey") String? apiKey,
    @Query("country") String? country,
    @Query("category") String? category,
  });
}
