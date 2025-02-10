part of 'post_bloc.dart';

enum PostStatus {
  loading,
  loaded,
  deleted,
  liked,
  error,
}

class PostState {
  final PostStatus status;
  final Post? post;
  final AppException? exception;

  PostState({required this.status, this.post, this.exception});
}
