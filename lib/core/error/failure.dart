abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure(super.message);
}

class ServiceUnavailableFailure extends Failure {
  const ServiceUnavailableFailure(super.message);
}

class GatewayTimeoutFailure extends Failure {
  const GatewayTimeoutFailure(super.message);
}

class InternalServerErrorFailure extends Failure {
  const InternalServerErrorFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}