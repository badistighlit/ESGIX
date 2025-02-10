import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/exceptions/global/app_exception.dart';
import 'package:projet_esgix/models/post_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';

part 'post_list_event.dart';
part 'post_list_state.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final PostRepository repository;

  PostListBloc({required this.repository}): super(PostListState()) {
    on<GetAllPosts> (_onGetAllPosts);
    on<GetUserPosts> (_onGetUserPosts);
  }

  Future<void> _onGetAllPosts(GetAllPosts event, Emitter<PostListState> emit) async {
    emit(PostListState.copyWith(status: PostListStatus.loading));
    try {
      List<Post> posts = await repository.getPosts();

      if (posts.isEmpty) {
        emit(PostListState.copyWith(status: PostListStatus.empty));

        return;
      }

      emit(PostListState.copyWith(status: PostListStatus.success, posts: posts));
    } catch (e) {
      emit(PostListState.copyWith(status: PostListStatus.failure, exception: AppException.from(e)));
    }
  }

  Future<void> _onGetUserPosts(GetUserPosts event, Emitter<PostListState> emit) async {
    emit(PostListState.copyWith(status: PostListStatus.loading));
    try {
      List<Post> posts;

      if (event.likedPosts) {
        posts = await repository.getUserPosts(event.userId, liked: true);
      } else {
        posts = await repository.getUserPosts(event.userId);
      }

      if (posts.isEmpty) {
        emit(PostListState.copyWith(status: PostListStatus.empty));

        return;
      }

      emit(PostListState.copyWith(status: PostListStatus.success, posts: posts));
    } catch (e) {
      emit(PostListState.copyWith(status: PostListStatus.failure, exception: AppException.from(e)));
    }
  }
}