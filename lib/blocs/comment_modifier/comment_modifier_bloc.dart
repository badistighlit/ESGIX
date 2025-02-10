
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/exceptions/global/app_exception.dart';
import 'package:projet_esgix/models/comment_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';

part 'comment_modifier_event.dart';
part 'comment_modifier_state.dart';

class CommentModifierBloc extends Bloc<CommentModifierEvent, CommentModifierState> {
  final PostRepository repository;

  CommentModifierBloc({required this.repository}): super(const CommentModifierState()) {
    on<CreateComment>(_onCreateComment);
    on<DeleteComment>(_onDeleteComment);
  }

  void _onCreateComment(CreateComment event, Emitter<CommentModifierState> emit) async {
    emit(CommentModifierState(status: CommentModifierStatus.addingComment));
    try {
      final success = await repository.createComment(event.comment);

      if (success) {
        emit(CommentModifierState(status: CommentModifierStatus.successAddingComment));
      }
    } catch (e) {
      emit(CommentModifierState(status: CommentModifierStatus.errorAddingComment, exception: AppException.from(e)));
    }
  }

  void _onDeleteComment(DeleteComment event, Emitter<CommentModifierState> emit) async {
    emit(CommentModifierState(status: CommentModifierStatus.deletingComment));
    try {
      final success = await repository.deletePostById(event.comment.id);

      if (success) {
        emit(CommentModifierState(status: CommentModifierStatus.successDeletingComment));
      }
    } catch (e) {
      emit(CommentModifierState(status: CommentModifierStatus.errorDeletingComment, exception: AppException.from(e)));
    }
  }
}
