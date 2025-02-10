part of 'post_bloc.dart';

sealed class PostEvent {
  final String postId;

  PostEvent(this.postId);
}

class GetPost extends PostEvent {
  GetPost(super.postId);
}

class DeletePost extends PostEvent {
  DeletePost(super.postId);
}

class LikePost extends PostEvent {
  LikePost(super.postId);
}
