part of 'comment_list_bloc.dart';


enum CommentListStatus {
  loading,
  success,
  failure,
  empty,
}

class CommentListState {
  final List<CommentModel> comments;
  final CommentListStatus status;
  final AppException? exception;

  CommentListState({this.status = CommentListStatus.loading, this.comments = const [], this.exception});

  static CommentListState copyWith({required CommentListStatus status, List<CommentModel> comments = const [], AppException? exception}) {
    return CommentListState(
      status: status,
      comments: comments,
      exception: exception
    );
  }
}