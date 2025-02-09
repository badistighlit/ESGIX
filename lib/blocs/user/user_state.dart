part of "user_bloc.dart";

enum UserStateStatus {
  loading,
  success,
  failure,
}

class UserState {
  final UserStateStatus status;
  final User? user;
  final AppException? exception;

  const UserState({
    this.status = UserStateStatus.loading,
    this.user,
    this.exception,
  });

  UserState copyWith({required UserStateStatus status, User? user, AppException? exception}) {
    return UserState(
        status: status,
        user: user,
        exception: exception
    );
  }
}
