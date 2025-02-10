part of 'comment_list_bloc.dart';

sealed class CommentListEvent {}

class GetAllComments extends CommentListEvent {
  final String parentPostId;

  GetAllComments({required this.parentPostId});
}
