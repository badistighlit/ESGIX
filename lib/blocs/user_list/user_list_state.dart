part of 'user_list_bloc.dart';


enum UserListStatus {
  loading,
  success,
  failure,
  empty,
}

class UserListState {
  final List<Author> users;
  final UserListStatus status;
  final AppException? exception;

  UserListState({this.status = UserListStatus.loading, this.users= const [], this.exception});

  static UserListState copyWith({required UserListStatus status, List<Author> users = const [], AppException? exception}) {
    return UserListState(
        status: status,
        users: users,
        exception: exception
    );
  }
}