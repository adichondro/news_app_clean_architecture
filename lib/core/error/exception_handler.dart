import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constant/app_strings.dart';
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
          AppStrings.connectionTimeout,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.badCertificate:
        return const ServerFailure(
          AppStrings.invalidSslCertificate,
        );

      case DioExceptionType.cancel:
        return const ServerFailure(AppStrings.requestCancelled);

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkFailure(AppStrings.noInternetConnection);
        }

        return const ServerFailure(AppStrings.unexpectedError);
    }
  }

  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure(AppStrings.noServerResponse);
    }

    final statusCode = response.statusCode;

    String message = AppStrings.serverErrorDefault;

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
          AppStrings.sessionExpired,
        );

      case 404:
        return const NotFoundFailure(AppStrings.resourceNotFound);

      case 422:
        return ValidationFailure('Validation failed: $message');

      case 429:
        return const TooManyRequestsFailure(
          AppStrings.tooManyRequests,
        );

      case 500:
        return ServerFailure('Internal Server Error: $message');

      case 502:
        return const ServerFailure(
          AppStrings.badGateway,
        );

      case 503:
        return const ServerFailure(
          AppStrings.serviceUnavailable,
        );

      case 504:
        return const ServerFailure(
          AppStrings.gatewayTimeout,
        );

      default:
        return ServerFailure('Something went wrong (Error Code: $statusCode).');
    }
  }
}
