import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/post/post_event.dart';
import 'package:projet_esgix/blocs/post/post_state.dart';

import '../../repositories/post_repository.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  PostBloc({required this.repository}) : super(PostInitial()) {
    on<FetchPosts>((event, emit) async {
      emit(PostLoading());
      try {
        final posts = await repository.getPosts(
          page: event.page,
          offset: event.offset,
        );
        emit(PostLoaded(posts));
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });
  }
}