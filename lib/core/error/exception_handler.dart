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
        return const NetworkFailure(
          'Connection timed out. Please check your internet connection and try again.',
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.badCertificate:
        return const ServerFailure(
          'Secure connection failed: Invalid SSL certificate.',
        );

      case DioExceptionType.cancel:
        return const ServerFailure('The request was cancelled.');

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkFailure('No internet connection.');
        }

        return const ServerFailure('An unexpected error occurred.');
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure('No response received from the server.');
    }

    final statusCode = response.statusCode;

    String message = 'A server error occurred.';

    if (response.data is Map<String, dynamic>) {
      message = response.data['message'] ?? message;
    } else if (response.data is String) {
      message = response.data;
    }

    switch (statusCode) {
      case 400:
        return ServerFailure('Bad Request: $message');

      case 401:
      case 403:
        return const UnauthorizedFailure(
          'Access denied or session expired. Please sign in again.',
        );

      case 404:
        return const NotFoundFailure('The requested resource was not found.');

      case 422:
        return ValidationFailure('Validation failed: $message');

      case 429:
        return const TooManyRequestsFailure(
          'Too many requests. Please try again later.',
        );

      case 500:
        return ServerFailure('Internal Server Error: $message');

      case 502:
        return const ServerFailure(
          'Bad Gateway: The server received an invalid response.',
        );

      case 503:
        return const ServerFailure(
          'Service Unavailable: The server is temporarily unavailable.',
        );

      case 504:
        return const ServerFailure(
          'Gateway Timeout: The server did not respond in time.',
        );

      default:
        return ServerFailure('Something went wrong (Error Code: $statusCode).');
    }
  }
}
