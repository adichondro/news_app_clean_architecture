import 'package:news_app_clean_architecture/core/error/failure.dart';

abstract class DataState<T> {
  final T? data;
  final Failure? error;

  const DataState({this.data, this.error});

  R fold<R>(R Function(Failure error) onFailure, R Function(T data) onSuccess) {
    if (this is DataFailed) {
      return onFailure(error!);
    } else if (this is DataSuccess) {
      return onSuccess(data as T);
    } else {
      throw Exception('DataState is neither Success nor Failed');
    }
  }
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  const DataFailed(Failure error) : super(error: error);
}
