import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:news_app_clean_architecture/core/constant/api_constants.dart';
import 'package:news_app_clean_architecture/core/network/interceptors/api_key_interceptor.dart';

/// Factory utility responsible for constructing and configuring pre-configured [Dio] HTTP client instances.
class NewsDioClient {
  /// Private constructor to prevent class instantiation.
  const NewsDioClient._();

  /// Creates a configured [Dio] client with default base URL, connection timeouts, and interceptors.
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(ApiKeyInterceptor());

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          responseHeader: true,
          responseBody: false,
        ),
      );
    }

    return dio;
  }
}

