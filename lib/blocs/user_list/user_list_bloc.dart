import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/models/comment_model.dart';
import '../../exceptions/global/app_exception.dart';
import '../../repositories/post_repository.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final PostRepository repository;

  UserListBloc({required this.repository}) : super(UserListState()) {
    on<GetPostLikes>(_onGetPostLikes);
  }

  Future<void> _onGetPostLikes(GetPostLikes event, Emitter<UserListState> emit) async {
    emit(UserListState.copyWith(status: UserListStatus.loading));
    try {
      List<Author> users = await repository.getPostLikes(event.idPost);
      if (users.isEmpty) {
        emit(UserListState.copyWith(status: UserListStatus.empty));
        return;
      }
      emit(UserListState.copyWith(status: UserListStatus.success, users: users));
    } catch (e) {
      emit(UserListState.copyWith(status: UserListStatus.failure, exception: AppException.from(e)));
    }
  }
}
