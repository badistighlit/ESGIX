part of 'post_list_bloc.dart';


enum PostListStatus {
  loading,
  success,
  failure,
  empty,
}

class PostListState {
  final List<Post> posts;
  final PostListStatus status;
  final AppException? exception;

  PostListState({this.status = PostListStatus.loading, this.posts = const [], this.exception});

  static PostListState copyWith({required PostListStatus status, List<Post> posts = const [], AppException? exception}) {
    return PostListState(
      status: status,
      posts: posts,
      exception: exception
    );
  }
}