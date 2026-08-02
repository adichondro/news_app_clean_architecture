import 'package:news_app_clean_architecture/core/error/failure.dart';

/// Abstract functional wrapper representing either a successful result or a failure.
abstract class DataState<T> {
  /// Holds payload data when the state is [DataSuccess].
  final T? data;

  /// Holds error details when the state is [DataFailed].
  final Failure? error;

  /// Creates a [DataState] with optional [data] or [error].
  const DataState({this.data, this.error});

  /// Folds the state into a single value by executing [onFailure] or [onSuccess].
  R fold<R>(R Function(Failure error) onFailure, R Function(T data) onSuccess) {
    // Execute failure callback if instance is DataFailed
    if (this is DataFailed) {
      return onFailure(error!);
    } 
    // Execute success callback if instance is DataSuccess
    else if (this is DataSuccess) {
      return onSuccess(data as T);
    } 
    
    // Fallback error if DataState is neither DataFailed nor DataSuccess
    throw Exception('DataState is neither Success nor Failed');
  }
}

/// Represents a successful operation state holding data of type [T].
class DataSuccess<T> extends DataState<T> {
  /// Creates a successful state holding [data].
  const DataSuccess(T data) : super(data: data);
}

/// Represents a failed operation state holding a [Failure].
class DataFailed<T> extends DataState<T> {
  /// Creates a failed state holding [error].
  const DataFailed(Failure error) : super(error: error);
}

