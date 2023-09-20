sealed class NetworkState {}

class NetworkStateLoading extends NetworkState {}

class NetworkStateSuccess<T> extends NetworkState {
  final T data;
  NetworkStateSuccess({required this.data});
}

class NetworkStateError extends NetworkState {
  final String errorMessage;

  NetworkStateError({required this.errorMessage});
}
