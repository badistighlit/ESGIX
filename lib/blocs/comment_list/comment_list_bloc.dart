import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/exceptions/global/app_exception.dart';
import 'package:projet_esgix/models/comment_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';

part 'comment_list_event.dart';
part 'comment_list_state.dart';

class CommentListBloc extends Bloc<CommentListEvent, CommentListState> {
  final PostRepository repository;

  CommentListBloc({required this.repository}): super(CommentListState()) {
    on<GetAllComments> (_onGetAllComments);
  }

  Future<void> _onGetAllComments(GetAllComments event, Emitter<CommentListState> emit) async {
    emit(CommentListState.copyWith(status: CommentListStatus.loading));
    try {
      List<CommentModel> comments = await repository.getComments(event.parentPostId);

      if (comments.isEmpty) {
        emit(CommentListState.copyWith(status: CommentListStatus.empty));

        return;
      }

      emit(CommentListState.copyWith(status: CommentListStatus.success, comments: comments));
    } catch (e) {
      emit(CommentListState.copyWith(status: CommentListStatus.failure, exception: AppException.from(e)));
    }
  }
}