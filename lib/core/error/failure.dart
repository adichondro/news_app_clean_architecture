import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;
  const Failure([this.message]);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message]);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message]);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message]);
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure([super.message]);
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure([super.message]);
}

class GatewayTimeoutFailure extends Failure {
  const GatewayTimeoutFailure([super.message]);
}

class InternalServerErrorFailure extends Failure {
  const InternalServerErrorFailure([super.message]);
}

class BadCertificateFailure extends Failure {
  const BadCertificateFailure([super.message]);
}

class RequestCancelledFailure extends Failure {
  const RequestCancelledFailure([super.message]);
}

class FormatFailure extends Failure {
  const FormatFailure([super.message]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}