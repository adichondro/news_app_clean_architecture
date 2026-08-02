import 'package:equatable/equatable.dart';

/// Base abstract class representing domain-level failures across the application.
abstract class Failure extends Equatable {
  /// Optional human-readable error message detailing the cause of failure.
  final String? message;

  /// Creates a [Failure] instance with an optional error [message].
  const Failure([this.message]);

  @override
  List<Object?> get props => [message];
}

/// Represents a general server error response (HTTP 500/502).
class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

/// Represents a local cache, SQLite, or storage operation failure.
class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

/// Represents a network connectivity or socket connection failure.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

/// Represents an unauthorized request failure (HTTP 401).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message]);
}

/// Represents a forbidden access failure (HTTP 403).
class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message]);
}

/// Represents a resource not found failure (HTTP 404).
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message]);
}

/// Represents a request validation or unprocessable entity failure (HTTP 422).
class ValidationFailure extends Failure {
  const ValidationFailure([super.message]);
}

/// Represents a rate limiting or too many requests failure (HTTP 429).
class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure([super.message]);
}

/// Represents a service temporarily unavailable failure (HTTP 503).
class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure([super.message]);
}

/// Represents a gateway timeout failure (HTTP 504).
class GatewayTimeoutFailure extends Failure {
  const GatewayTimeoutFailure([super.message]);
}

/// Represents an internal server error failure (HTTP 500).
class InternalServerErrorFailure extends Failure {
  const InternalServerErrorFailure([super.message]);
}

/// Represents an invalid or untrusted SSL certificate failure.
class BadCertificateFailure extends Failure {
  const BadCertificateFailure([super.message]);
}

/// Represents an HTTP request cancellation failure.
class RequestCancelledFailure extends Failure {
  const RequestCancelledFailure([super.message]);
}

/// Represents a JSON payload data format/parsing failure.
class FormatFailure extends Failure {
  const FormatFailure([super.message]);
}

/// Represents an unexpected or unclassified failure.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}