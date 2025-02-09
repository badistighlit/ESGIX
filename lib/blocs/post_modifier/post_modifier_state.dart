part of 'post_modifier_bloc.dart';

enum PostModifierStatus {
  initial,
  editingPost,
  addingPost,
  successAddingPost,
  successEditingPost,
  errorEditingPost,
  errorAddingPost,
}

class PostModifierState {
  final PostModifierStatus status;
  final Post? post;
  final AppException? exception;

  const PostModifierState({
    this.status = PostModifierStatus.initial,
    this.post,
    this.exception,
  });

  PostModifierState copyWith({
    PostModifierStatus? status,
    Post? post,
    AppException? exception,
  }) {
    return PostModifierState(
      status: this.status,
      post: this.post,
      exception: this.exception,
    );
  }
}