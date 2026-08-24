import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_clean_architecture/core/constant/app_strings.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';
import 'package:news_app_clean_architecture/core/util/failure_extension.dart';

/// Unit test suite for [FailureExtension].
///
/// Verifies mapping of technical [Failure] domain models to human-readable
/// UI strings, ensuring proper precedence for custom server messages.
void main() {
  group('FailureExtension Unit Tests', () {
    group('Custom message precedence', () {
      test('should return custom message when message is non-empty string', () {
        // Arrange: Create Failure instances with custom server messages
        const customNetwork = NetworkFailure('Custom network issue');
        const customServer = ServerFailure('Custom server error');

        // Act & Assert: Verify custom messages take precedence over defaults
        expect(customNetwork.toUserMessage(), equals('Custom network issue'));
        expect(customServer.toUserMessage(), equals('Custom server error'));
      });

      test('should fallback to default AppStrings when message is whitespace only', () {
        // Arrange: Create Failure with whitespace-only message
        const whitespaceFailure = ServerFailure('   ');

        // Act & Assert: Verify fallback to default message
        expect(whitespaceFailure.toUserMessage(), equals(AppStrings.serverErrorDefault));
      });
    });

    group('Default AppStrings mappings (when message is null)', () {
      test('should map NetworkFailure to connectionTimeout string', () {
        const failure = NetworkFailure();
        expect(failure.toUserMessage(), equals(AppStrings.connectionTimeout));
      });

      test('should map UnauthorizedFailure and ForbiddenFailure to sessionExpired string', () {
        const unauthorized = UnauthorizedFailure();
        const forbidden = ForbiddenFailure();

        expect(unauthorized.toUserMessage(), equals(AppStrings.sessionExpired));
        expect(forbidden.toUserMessage(), equals(AppStrings.sessionExpired));
      });

      test('should map BadCertificateFailure to invalidSslCertificate string', () {
        const failure = BadCertificateFailure();
        expect(failure.toUserMessage(), equals(AppStrings.invalidSslCertificate));
      });

      test('should map RequestCancelledFailure to requestCancelled string', () {
        const failure = RequestCancelledFailure();
        expect(failure.toUserMessage(), equals(AppStrings.requestCancelled));
      });

      test('should map NotFoundFailure to resourceNotFound string', () {
        const failure = NotFoundFailure();
        expect(failure.toUserMessage(), equals(AppStrings.resourceNotFound));
      });

      test('should map TooManyRequestsFailure to tooManyRequests string', () {
        const failure = TooManyRequestsFailure();
        expect(failure.toUserMessage(), equals(AppStrings.tooManyRequests));
      });

      test('should map ServiceUnavailableFailure to serviceUnavailable string', () {
        const failure = ServiceUnavailableFailure();
        expect(failure.toUserMessage(), equals(AppStrings.serviceUnavailable));
      });

      test('should map GatewayTimeoutFailure to gatewayTimeout string', () {
        const failure = GatewayTimeoutFailure();
        expect(failure.toUserMessage(), equals(AppStrings.gatewayTimeout));
      });

      test('should map ServerFailure to serverErrorDefault string', () {
        const failure = ServerFailure();
        expect(failure.toUserMessage(), equals(AppStrings.serverErrorDefault));
      });

      test('should map CacheFailure to failedToLoadSavedArticles string', () {
        const failure = CacheFailure();
        expect(failure.toUserMessage(), equals(AppStrings.failedToLoadSavedArticles));
      });

      test('should map FormatFailure to unexpectedError string', () {
        const failure = FormatFailure();
        expect(failure.toUserMessage(), equals(AppStrings.unexpectedError));
      });

      test('should map unhandled or generic failures to unexpectedError string', () {
        const unknown = UnknownFailure();
        const validation = ValidationFailure();
        const internalServer = InternalServerErrorFailure();

        expect(unknown.toUserMessage(), equals(AppStrings.unexpectedError));
        expect(validation.toUserMessage(), equals(AppStrings.unexpectedError));
        expect(internalServer.toUserMessage(), equals(AppStrings.unexpectedError));
      });
    });
  });
}
