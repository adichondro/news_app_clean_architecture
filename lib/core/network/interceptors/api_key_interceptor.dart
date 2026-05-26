import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/env/env.dart';

class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['apiKey'] = Env.apiKey;
    super.onRequest(options, handler);
  }
}
