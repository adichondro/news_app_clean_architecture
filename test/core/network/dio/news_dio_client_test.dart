import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/core/constant/api_constants.dart';
import 'package:news_app_clean_architecture/core/env/env.dart';
import 'package:news_app_clean_architecture/core/network/dio/news_dio_client.dart';
import 'package:news_app_clean_architecture/core/network/interceptors/api_key_interceptor.dart';

/// Unit test suite for [NewsDioClient] and [ApiKeyInterceptor].
///
/// Verifies HTTP client options, timeout thresholds, header declarations,
/// and automated API key parameter injection.
void main() {

  const tApiKey = 'test_api_key_12345';

  setUpAll(() {
    // Initialize mock environment variable for test runtime
    dotenv.loadFromString(envString: 'API_KEY=$tApiKey');
  });
  
  group('NewsDioClient Unit Tests', () {
    test('should construct Dio instance with correct base configuration', () {
      // Act: Create Dio instance via factory
      final dio = NewsDioClient.create();

      // Assert: Verify base URL matches ApiConstants
      expect(dio.options.baseUrl, equals(ApiConstants.baseUrl));

      // Assert: Verify connection and receive timeout thresholds (10s)
      expect(dio.options.connectTimeout, equals(const Duration(seconds: 10)));
      expect(dio.options.receiveTimeout, equals(const Duration(seconds: 10)));

      // Assert: Verify Content-Type header
      expect(dio.options.headers['Content-Type'], equals('application/json'));
    });

    test(
      'should attach [ApiKeyInterceptor] and [LogInterceptor] in debug mode',
      () {
        // Act: Create Dio instance via factory
        final dio = NewsDioClient.create();

        // Assert: Verify ApiKeyInterceptor is registered in interceptor chain
        expect(
          dio.interceptors.any(
            (interceptor) => interceptor is ApiKeyInterceptor,
          ),
          isTrue,
        );

        // Assert: Verify LogInterceptor is registered
        expect(
          dio.interceptors.any((interceptor) => interceptor is LogInterceptor),
          isTrue,
        );
      },
    );
  });

  group('ApiKeyInterceptor Unit Tests', () {
    test('should automatically inject apiKey into request query parameters', () {
      // Arrange: Prepare interceptor and mock request options
      final interceptor = ApiKeyInterceptor();
      final handler = RequestInterceptorHandler();
      final options = RequestOptions(
        path: '/top-headlines',
        queryParameters: {'country': 'us'},
      );

      // Act: Execute onRequest interceptor hook
      interceptor.onRequest(options, handler);

      // Assert: Verify apiKey parameter is appended
      expect(options.queryParameters['apiKey'], equals(Env.apiKey));
      expect(options.queryParameters['country'], equals('us'));
    });
  });
}
