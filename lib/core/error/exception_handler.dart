import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';

class ExceptionHandler {
  static Failure handleDioException(DioException error) {
    // Log error for production debugging
    developer.log(
      'API Request Failed',
      name: 'ExceptionHandler',
      error: error,
      stackTrace: error.stackTrace,
    );

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.badCertificate:
        return const ServerFailure('Invalid SSL certificate.');

      case DioExceptionType.cancel:
        return const ServerFailure('Request was cancelled.');

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkFailure();
        }
        return const UnknownFailure();
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure();
    }

    final statusCode = response.statusCode;

    String? serverMessage;
    if (response.data is Map<String, dynamic>) {
      serverMessage = response.data['message'];
    } else if (response.data is String && (response.data as String).isNotEmpty) {
      serverMessage = response.data;
    }

    switch (statusCode) {
      case 400:
        return ServerFailure(serverMessage ?? 'Bad Request');

      case 401:
      case 403:
        return const UnauthorizedFailure();

      case 404:
        return const NotFoundFailure();

      case 422:
        return ValidationFailure(serverMessage ?? 'Validation failed');

      case 429:
        return const TooManyRequestsFailure();

      case 500:
        return InternalServerErrorFailure(serverMessage);

      case 502:
        return const ServerFailure();

      case 503:
        return const ServiceUnavailableFailure();

      case 504:
        return const GatewayTimeoutFailure();

      default:
        return UnknownFailure('Error Code: $statusCode');
    }
  }
}
