import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/env/env.dart';

/// Dio interceptor that automatically attaches the API key to outbound HTTP request query parameters.
class ApiKeyInterceptor extends Interceptor {
  /// Appends [Env.apiKey] to the query parameters of every outbound HTTP request.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['apiKey'] = Env.apiKey;
    super.onRequest(options, handler);
  }
}

