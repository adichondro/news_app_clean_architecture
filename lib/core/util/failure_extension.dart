import 'package:news_app_clean_architecture/core/constant/app_strings.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';

extension FailureExtension on Failure {
  /// Maps a technical [Failure] into a user-friendly UI display string.
  String toUserMessage() {
    // If a specific server message was provided, prefer displaying it
    if (message != null && message!.trim().isNotEmpty) {
      return message!;
    }

    // Dart 3 Pattern Matching for clean, exhaustive type checks
    return switch (this) {
      NetworkFailure() => AppStrings.connectionTimeout,
      UnauthorizedFailure() => AppStrings.sessionExpired,
      NotFoundFailure() => AppStrings.resourceNotFound,
      TooManyRequestsFailure() => AppStrings.tooManyRequests,
      ServiceUnavailableFailure() => AppStrings.serviceUnavailable,
      GatewayTimeoutFailure() => AppStrings.gatewayTimeout,
      ServerFailure() => AppStrings.serverErrorDefault,
      CacheFailure() => AppStrings.failedToLoadSavedArticles,
      _ => AppStrings.unexpectedError,
    };
  }
}
