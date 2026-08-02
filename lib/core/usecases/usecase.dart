// ignore_for_file: avoid_types_as_parameter_names

/// Abstract base interface for all application business use cases.
///
/// Enforces a callable interface pattern accepting optional [params].
abstract class UseCase<Type, Params> {
  /// Executes the business logic associated with the use case.
  Future<Type> call({Params params});
}

