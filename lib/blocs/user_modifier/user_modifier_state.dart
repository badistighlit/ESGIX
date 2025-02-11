part of 'user_modifier_bloc.dart';

enum UserModifierStatus {
  initial,
  editingPost,
  addingPost,
  successAddingPost,
  successEditingPost,
  errorEditingPost,
  errorAddingPost,
}

class UserModifierState {
  final UserModifierStatus status;
  final User? user;
  final AppException? exception;

  const UserModifierState({
    this.status = UserModifierStatus.initial,
    this.user,
    this.exception,
  });

  UserModifierState copyWith({
    UserModifierStatus? status,
    AuthUser? authUser,
    AppException? exception,
  }) {
    return UserModifierState(
      status: this.status,
      user: this.user,
      exception: this.exception,
    );
  }
}