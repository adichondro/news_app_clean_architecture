import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';

/// Centralized exception utility for mapping data layer exceptions to domain [Failure]s.
///
/// Serves as the primary entry point for converting network, parsing, and database errors 
/// into strongly-typed [Failure] objects for repositories and BLoCs.
class ExceptionHandler {
  /// Handles and converts any data layer [error] into a domain [Failure].
  static Failure handleException(Object error) {
    if (error is DioException) {
      return handleDioException(error);
    } else if (error is FormatException) {
      return const FormatFailure();
    } else if (error is Failure) {
      return error;
    }
    return UnknownFailure(error.toString());
  }

  /// Processes network and HTTP client exceptions originating from [Dio].
  ///
  /// Evaluates connection timeouts, bad responses, certificates, and cancellations.
  /// Emits structured logs via [developer.log] when executed under [kDebugMode].
  static Failure handleDioException(DioException error) {
    if (kDebugMode) {
      developer.log(
        'API Request Failed',
        name: 'ExceptionHandler',
        error: error,
        stackTrace: error.stackTrace,
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.badCertificate:
        return const BadCertificateFailure();

      case DioExceptionType.cancel:
        return const RequestCancelledFailure();

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkFailure();
        }
        return const UnknownFailure();
    }
  }

  /// Maps HTTP status codes from a server response to corresponding [Failure] instances.
  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const ServerFailure();
    }

    final statusCode = response.statusCode;
    final String? serverMessage = _extractServerMessage(response.data);

    switch (statusCode) {
      case 400:
        return ServerFailure(serverMessage);

      case 401:
        return const UnauthorizedFailure();

      case 403:
        return const ForbiddenFailure();

      case 404:
        return const NotFoundFailure();

      case 422:
        return ValidationFailure(serverMessage);

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
        return UnknownFailure(serverMessage ?? 'Error Code: $statusCode');
    }
  }

  /// Dynamically parses server error messages from standard REST response payloads.
  ///
  /// Inspects common JSON keys ('message', 'error', 'detail', 'errors') in order of precedence.
  static String? _extractServerMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['message'] is String && (data['message'] as String).isNotEmpty) {
        return data['message'];
      }
      if (data['error'] is String && (data['error'] as String).isNotEmpty) {
        return data['error'];
      }
      if (data['detail'] is String && (data['detail'] as String).isNotEmpty) {
        return data['detail'];
      }
      if (data['errors'] is List && (data['errors'] as List).isNotEmpty) {
        return (data['errors'] as List).join(', ');
      }
    } else if (data is String && data.isNotEmpty) {
      return data;
    }
    return null;
  }
}






