import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/env/env.dart';
import 'package:news_app_clean_architecture/core/network/interceptors/api_key_interceptor.dart'
    show ApiKeyInterceptor;

/// Mock implementation of Dio's [RequestInterceptoprHandler] using mocktail.
class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

/// Unit test suite for [ApiKeyInterceptor].
///
///  Verifies outbound HTTP request contrect for attaching API security credentials.
void main() {
  late ApiKeyInterceptor interceptor;
  late MockRequestInterceptorHandler mockRequestInterceptorHandler;

  const tApiKey = 'test_api_key_12345';

  setUpAll(() {
    dotenv.loadFromString(envString: 'API_KEY=$tApiKey');
  });

  setUp(() {
    interceptor = ApiKeyInterceptor();
    mockRequestInterceptorHandler = MockRequestInterceptorHandler();
  });

  group('ApiKeyInterceptor Contract & Securitu Tests', () {
    test(
      'should append [apiKey] parameter to existing queryParameters on [onRequest]',
      () async {
        // Arrange: Prepare request with existing query parameters
        final options = RequestOptions(
          path: '/v2/top-headlines',
          queryParameters: {'country': 'us'},
        );

        // Act: Execute interceptor
        interceptor.onRequest(options, mockRequestInterceptorHandler);

        // Assert: Verify  apiKey is appended correctly alongside existing parameters
        expect(options.queryParameters['apiKey'], equals(tApiKey));
        expect(options.queryParameters['country'], equals('us'));
        expect(Env.apiKey, equals(tApiKey));
        verify(() => mockRequestInterceptorHandler.next(options)).called(1);
      },
    );

    test(
      'shoudl append [apiKey] correctly when queryParameters is initially empty',
      () {
        // Arrange: Prepare request with empty query parametes map
        final options = RequestOptions(
          path: '/v2/everything',
          queryParameters: <String, dynamic>{},
        );

        // Act: Execute interceptor
        interceptor.onRequest(options, mockRequestInterceptorHandler);

        // Assert: Verify apiKey is safely added to empty map
        expect(options.queryParameters.containsKey('apiKey'), isTrue);
        expect(options.queryParameters['apiKey'], equals(tApiKey));
        verify(() => mockRequestInterceptorHandler.next(options)).called(1);
      },
    );
  });
}
