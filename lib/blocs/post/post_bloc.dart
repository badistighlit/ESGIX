import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/exceptions/global/app_exception.dart';
import 'package:projet_esgix/models/post_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';


part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  PostBloc({required this.repository}) : super(PostState(status: PostStatus.loading)) {
    on<GetPost>(_getPost);
    on<DeletePost>(_deletePost);
    on<LikePost>(_likePost);
  }
  void _getPost(GetPost event, Emitter<PostState> emit) async {
    emit(PostState(status: PostStatus.loading));
    try {
      final post = await repository.getPostById(event.postId);

      emit(PostState(status: PostStatus.loaded, post: post));
    } catch (e) {
      emit(PostState(status: PostStatus.error, exception: AppException.from(e)));
    }
  }

  void _deletePost(DeletePost event, Emitter<PostState> emit) async {
    emit(PostState(status: PostStatus.loading));
    try {
      final deleted = await repository.deletePostById(event.postId);

      if (deleted) {
        emit(PostState(status: PostStatus.deleted));
      }
    } catch (e) {
      emit(PostState(status: PostStatus.error, exception: AppException.from(e)));
    }
  }

  void _likePost(LikePost event, Emitter<PostState> emit) async {
    emit(PostState(status: PostStatus.loading));
    try {
      final liked = await repository.likePost(event.postId);

      if (liked) {
        final post = await repository.getPostById(event.postId);

        emit(PostState(status: PostStatus.liked, post: post));
      }
    } catch (e) {
      emit(PostState(status: PostStatus.error, exception: AppException.from(e)));
    }
  }
}