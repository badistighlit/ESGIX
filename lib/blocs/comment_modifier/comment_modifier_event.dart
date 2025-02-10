part of 'comment_modifier_bloc.dart';

sealed class CommentModifierEvent {
  final CommentModel comment;

  CommentModifierEvent(this.comment);
}

class CreateComment extends CommentModifierEvent {
  CreateComment(super.comment);
}

class DeleteComment extends CommentModifierEvent {
  DeleteComment(super.comment);
}
