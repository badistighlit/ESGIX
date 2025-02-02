part of "user_bloc.dart";

enum Status {
  loading,
  success,
  failure,
}

class UserState {
  final Status status;
  final User? user;
  final AppException? exception;

  const UserState({
    this.status = Status.loading,
    this.user,
    this.exception,
  });

  UserState copyWith({required Status status, User? user, AppException? exception}) {
    return UserState(
        status: status,
        user: user,
        exception: exception
    );
  }
}
