import 'package:news_app_clean_architecture/core/constant/app_strings.dart';
import 'package:news_app_clean_architecture/core/error/failure.dart';

/// Extension utility converting technical [Failure] instances into user-friendly UI display strings.
extension FailureExtension on Failure {
  /// Maps a technical [Failure] instance into a user-friendly UI message.
  String toUserMessage() {
    // Prefer server-provided custom error message if available
    if (message != null && message!.trim().isNotEmpty) {
      return message!;
    }

    // Match concrete Failure types to localized AppStrings UI messages
    return switch (this) {
      NetworkFailure() => AppStrings.connectionTimeout,
      UnauthorizedFailure() || ForbiddenFailure() => AppStrings.sessionExpired,
      BadCertificateFailure() => AppStrings.invalidSslCertificate,
      RequestCancelledFailure() => AppStrings.requestCancelled,
      NotFoundFailure() => AppStrings.resourceNotFound,
      TooManyRequestsFailure() => AppStrings.tooManyRequests,
      ServiceUnavailableFailure() => AppStrings.serviceUnavailable,
      GatewayTimeoutFailure() => AppStrings.gatewayTimeout,
      ServerFailure() => AppStrings.serverErrorDefault,
      CacheFailure() => AppStrings.failedToLoadSavedArticles,
      FormatFailure() => AppStrings.unexpectedError,
      _ => AppStrings.unexpectedError,
    };
  }
}

