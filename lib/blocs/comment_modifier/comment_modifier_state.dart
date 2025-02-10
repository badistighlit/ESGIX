part of 'comment_modifier_bloc.dart';

enum CommentModifierStatus {
  initial,
  addingComment,
  deletingComment,
  successAddingComment,
  successDeletingComment,
  errorAddingComment,
  errorDeletingComment,
}

class CommentModifierState {
  final CommentModifierStatus status;
  final CommentModel? comment;
  final AppException? exception;

  const CommentModifierState({
    this.status = CommentModifierStatus.initial,
    this.comment,
    this.exception,
  });

  CommentModifierState copyWith({
    CommentModifierStatus? status,
    CommentModel? comment,
    AppException? exception,
  }) {
    return CommentModifierState(
      status: this.status,
      comment: this.comment,
      exception: this.exception,
    );
  }
}
