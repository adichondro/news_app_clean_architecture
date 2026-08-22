import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/core/error/exception_handler.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';

/// Unit test suite for [ExceptionHandler].
///
/// Verifies centralized conversion of raw HTTP, system, and parsing exceptions
/// into strongly-typed domain [Failure] instances.
void main() {
  group('ExceptionHandler Unit Tests', () {
    group('handleException routing', () {
      test('should route DioException to handleDioException', () {
        // Arrange: Create a DioException instance
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionTimeout,
        );

        // Act: Handle the raw DioException
        final result = ExceptionHandler.handleException(dioError);

        // Assert: Verify mapping to NetworkFailure
        expect(result, isA<NetworkFailure>());
      });

      test('should return [FormatFailure] when error is a FormatException', () {
        // Act: Handle FormatException
        final result = ExceptionHandler.handleException(
          const FormatException('Bad JSON format'),
        );

        // Assert: Verify mapping to FormatFailure
        expect(result, isA<FormatFailure>());
      });

      test(
        'should return the original Failure when error is already a [Failure]',
        () {
          // Arrange: Prepare existing Failure instance
          const originalFailure = ServerFailure('Custom server error');

          // Act: Handle already-typed failure
          final result = ExceptionHandler.handleException(originalFailure);

          // Assert: Verify failure instance is passed through unchanged
          expect(result, equals(originalFailure));
        },
      );

      test('should return [UnknownFailure] for unhandled raw objects', () {
        // Act: Handle unexpected raw string object
        final result = ExceptionHandler.handleException(
          'Unexpected error string',
        );

        // Assert: Verify fallback to UnknownFailure with original string message
        expect(result, isA<UnknownFailure>());
        expect(result.message, equals('Unexpected error string'));
      });
    });

    group('handleDioException mappings', () {
      /// Helper function to generate mock [DioException] instances.
      DioException createDioException({
        required DioExceptionType type,
        Response? response,
        Object? error,
      }) {
        return DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: type,
          response: response,
          error: error,
        );
      }

      test('should return [NetworkFailure] on timeout types', () {
        // Assert: Verify connection, send, and receive timeouts map to NetworkFailure
        expect(
          ExceptionHandler.handleDioException(
            createDioException(type: DioExceptionType.connectionTimeout),
          ),
          isA<NetworkFailure>(),
        );
        expect(
          ExceptionHandler.handleDioException(
            createDioException(type: DioExceptionType.sendTimeout),
          ),
          isA<NetworkFailure>(),
        );
        expect(
          ExceptionHandler.handleDioException(
            createDioException(type: DioExceptionType.receiveTimeout),
          ),
          isA<NetworkFailure>(),
        );
      });

      test('should return [BadCertificateFailure] on badCertificate', () {
        // Act: Handle SSL/TLS certificate failure
        final result = ExceptionHandler.handleDioException(
          createDioException(type: DioExceptionType.badCertificate),
        );

        // Assert: Verify mapping to BadCertificateFailure
        expect(result, isA<BadCertificateFailure>());
      });

      test('should return [RequestCancelledFailure] on cancel', () {
        // Act: Handle cancelled request
        final result = ExceptionHandler.handleDioException(
          createDioException(type: DioExceptionType.cancel),
        );

        // Assert: Verify mapping to RequestCancelledFailure
        expect(result, isA<RequestCancelledFailure>());
      });

      test(
        'should return [NetworkFailure] when connectionError or unknown contains SocketException',
        () {
          // Arrange: Prepare SocketException representing connectivity loss
          const socketError = SocketException('No Internet');

          // Assert: Verify connectionError with SocketException maps to NetworkFailure
          expect(
            ExceptionHandler.handleDioException(
              createDioException(
                type: DioExceptionType.connectionError,
                error: socketError,
              ),
            ),
            isA<NetworkFailure>(),
          );

          // Assert: Verify unknown with SocketException maps to NetworkFailure
          expect(
            ExceptionHandler.handleDioException(
              createDioException(
                type: DioExceptionType.unknown,
                error: socketError,
              ),
            ),
            isA<NetworkFailure>(),
          );
        },
      );

      test(
        'should return [UnknownFailure] when connectionError or unknown has no SocketException',
        () {
          // Assert: Verify generic connection Error without SocketException maps to UnknownFailure
          expect(
            ExceptionHandler.handleDioException(
              createDioException(type: DioExceptionType.connectionError),
            ),
            isA<UnknownFailure>(),
          );

          // Assert: Verify generic unknown without SocketException maps to UnknownFailure
          expect(
            ExceptionHandler.handleDioException(
              createDioException(type: DioExceptionType.unknown),
            ),
            isA<UnknownFailure>(),
          );
        },
      );
    });

    group('HTTP status code mappings via _handleBadResponse', () {
      /// Helper function to generate bad response [DioException] with specific status codes.
    DioException createBadResponseException(int? statusCode, [dynamic data]) {
      return DioException(
        requestOptions: RequestOptions(path: '/api/v1/news'),
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: statusCode,
          requestOptions: RequestOptions(path: '/api/v1/news'),
          data: data,
        ),
      );
    }

    test('should return [ServerFailure] when response is null', () {
      // Arrange: Create badResponse DioException with null response
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.badResponse,
        response: null,
      );

      // Act: Handle null response badResponse
      final result = ExceptionHandler.handleDioException(dioError);

      // Assert: Verify fallback to ServerFailure
      expect(result, isA<ServerFailure>());
    });

      test('should map 400 to [ServerFailure]', () {
        // Act: Handle HTTP 400 Bad Request
        final result = ExceptionHandler.handleDioException(
          createBadResponseException(400, {'message': 'Bad Request syntax'}),
        );

        // Assert: Verify ServerFailure with parsed message
        expect(result, isA<ServerFailure>());
        expect(result.message, equals('Bad Request syntax'));
      });

      test('should map 401 to [UnauthorizedFailure]', () {
        // Act: Handle HTTP 401 Unauthorized
        final result = ExceptionHandler.handleDioException(
          createBadResponseException(401),
        );

        // Assert: Verify UnauthorizedFailure
        expect(result, isA<UnauthorizedFailure>());
      });

      test('should map 403 to [ForbiddenFailure]', () {
        // Act: Handle HTTP 403 Forbidden
        final result = ExceptionHandler.handleDioException(
          createBadResponseException(403),
        );

        // Assert: Verify ForbiddenFailure
        expect(result, isA<ForbiddenFailure>());
      });

    test('should map 404 to [NotFoundFailure]', () {
      // Act: Handle HTTP 404 Not Found
      final result = ExceptionHandler.handleDioException(
        createBadResponseException(404),
      );

      // Assert: Verify NotFoundFailure
      expect(result, isA<NotFoundFailure>());
    });

    test('should map 422 to [ValidationFailure]', () {
      // Act: Handle HTTP 422 Unprocessable Entity
      final result = ExceptionHandler.handleDioException(
        createBadResponseException(422, {'error': 'Unprocessable Entity'}),
      );

      // Assert: Verify ValidationFailure with parsed message
      expect(result, isA<ValidationFailure>());
      expect(result.message, equals('Unprocessable Entity'));
    });

    test('should map 429 to [TooManyRequestFailure]', () {
      // Act: Handle HTTP 429 Too Many Requests
      final result = ExceptionHandler.handleDioException(
        createBadResponseException(429),
      );

      // Assert: Verify TooManyRequestFailure
      expect(result, isA<TooManyRequestsFailure>());
    });

    test('should map 500 to [InternalServerErrorFailure]', () {
      // Act: Handle HTTP 500 Internal Server Error
      final result = ExceptionHandler.handleDioException(
        createBadResponseException(500, {'error': 'Database crashed'}),
      );

      // Assert: Verify InternalServerErrorFailure with parsed message
      expect(result, isA<InternalServerErrorFailure>());
      expect(result.message, equals('Database crashed'));
    });

      test('should map 502 to [ServerFailure]', () {
        // Act: Handle HTTP 502 Bad Gateway
        final result = ExceptionHandler.handleDioException(
          createBadResponseException(502),
        );

        // Assert: Verify ServerFailure
        expect(result, isA<ServerFailure>());
      });

    test('should map 503 to [ServiceUnavailableFailure]', () {
      // Act: Handle HTTP 503 Service Unavailable
      final result = ExceptionHandler.handleDioException(
        createBadResponseException(503),
      );

      // Assert: Verify ServiceUnavailableFailure
      expect(result, isA<ServiceUnavailableFailure>());
    });

    test('should map 504 to [GatewayTimeoutFailure]', () {
      // Act: Handle HTTP 504 Gateway Timeout
      final result = ExceptionHandler.handleDioException(
        createBadResponseException(504),
      );
      // Assert: Verify GatewayTimeoutFailure
      expect(result, isA<GatewayTimeoutFailure>());
    });

    test('should map unhandled status code (e.g. 418) to [UnknownFailure]', () {
      // Act: Handle unmapped HTTP status code
      final result = ExceptionHandler.handleDioException(
        createBadResponseException(418),
      );
      // Assert: Verify fallback to UnknownFailure with error code string
      expect(result, isA<UnknownFailure>());
      expect(result.message, equals('Error Code: 418'));
    });
  });

    group('Server message extraction parsing variations', () {
      /// Helper function to create response exception with dynamic data payload
      DioException createExceptionWithData(dynamic data) {
        return DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            data: data,
          ),
        );
      }

      test('should extract message from "message" field', () {
        // Act: Parse response payload with "message" key
        final result = ExceptionHandler.handleDioException(
          createExceptionWithData({'message': 'API Key invalid'}),
        );

        // Assert: Verify extracted message
        expect(result.message, equals('API Key invalid'));
      });

      test(
        'should extract message from "error" field when "message" is absent',
        () {
          // Act: Parse response payload containing 'error' key
          final result = ExceptionHandler.handleDioException(
            createExceptionWithData({'error': 'Rate limit reached'}),
          );

          // Assert: Verify extracted error message
          expect(result.message, equals('Rate limit reached'));
        },
      );

      test('should extract message from "detail" field', () {
        // Act: Parse response payload containing 'detail' key
        final result = ExceptionHandler.handleDioException(
          createExceptionWithData({'detail': 'Specific error detail'}),
        );
        // Assert: Verify extracted detail message
        expect(result.message, equals('Specific error detail'));
      });

      test('should extract and join list from "errors" field', () {
        // Act: Parse response payload containing 'errors' list
        final result = ExceptionHandler.handleDioException(
          createExceptionWithData({
            'errors': ['Field A required', 'Field B invalid'],
          }),
        );
        // Assert: Verify list elements are joined by commas
        expect(result.message, equals('Field A required, Field B invalid'));
      });

      test('should extract message directly when data is a raw String', () {
        // Act: Parse raw string error payload
        final result = ExceptionHandler.handleDioException(
          createExceptionWithData('Plain text error response'),
        );

        // Assert: Verify string payload is used directly as message
        expect(result.message, equals('Plain text error response'));
      });

      test('should return null message if data is empty map', () {
        // Act: Parse empty map payload
        final result = ExceptionHandler.handleDioException(
          createExceptionWithData(<String, dynamic>{}),
        );

        // Assert: Verify ServerFailure has null message
        expect(result, isA<ServerFailure>());
        expect(result.message, isNull);
      });
    });
  });
}
