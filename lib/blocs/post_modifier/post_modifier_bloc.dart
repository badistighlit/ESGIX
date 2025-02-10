
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/exceptions/global/app_exception.dart';
import 'package:projet_esgix/models/post_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';

part 'post_modifier_event.dart';
part 'post_modifier_state.dart';

class PostModifierBloc extends Bloc<PostModifierEvent, PostModifierState> {
  final PostRepository repository;

  PostModifierBloc({required this.repository}): super(const PostModifierState()) {
    on<CreatePost>(_onCreatePost);
    on<EditPost>(_onEditPost);
  }

  void _onCreatePost(CreatePost event, Emitter<PostModifierState> emit) async {
    emit(PostModifierState(status: PostModifierStatus.addingPost));
    try {
      final post = event.post;
      final success = await repository.createPost(post.content, post.imageUrl);

      if (success) {
        emit(PostModifierState(status: PostModifierStatus.successAddingPost));
      }
    } catch (e) {
      emit(PostModifierState(status: PostModifierStatus.errorAddingPost));
    }
  }

  void _onEditPost(EditPost event, Emitter<PostModifierState> emit) async {
    emit(PostModifierState(status: PostModifierStatus.editingPost));
    try {
      final post = event.post;
      final success = await repository.updatePost(post.id!, post.content, post.imageUrl);

      if (success) {
        emit(PostModifierState(status: PostModifierStatus.successEditingPost));
      }
    } catch (e) {
      emit(PostModifierState(status: PostModifierStatus.errorEditingPost));
    }
  }
}