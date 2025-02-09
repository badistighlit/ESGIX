part of 'post_modifier_bloc.dart';

sealed class PostModifierEvent {
  final Post post;

  PostModifierEvent(this.post);
}

class CreatePost extends PostModifierEvent {
  CreatePost(super.post);
}

class EditPost extends PostModifierEvent {
  EditPost(super.post);
}