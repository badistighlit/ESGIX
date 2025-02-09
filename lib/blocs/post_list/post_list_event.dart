part of 'post_list_bloc.dart';

sealed class PostListEvent {}

class GetAllPosts extends PostListEvent {}

class GetUserPosts extends PostListEvent {
  final bool likedPosts;
  final String userId;

  GetUserPosts({required this.userId, required this.likedPosts});
}