
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/global/app_exception.dart';
import '../../models/auth_user_model.dart';
import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';
part 'user_modifier_event.dart';
part 'user_modifier_state.dart';



class UserModifierBloc extends Bloc<UserModifierEvent, UserModifierState> {
  final UserRepository repository;

  UserModifierBloc({required this.repository}): super(const UserModifierState()) {
    on<EditUser>(_onEditUser);
  }


  void _onEditUser(EditUser event, Emitter<UserModifierState> emit) async {
    emit(UserModifierState(status: UserModifierStatus.editingPost));
    try {
      final user = event.user;
      final success = await repository.updateUser(user.id!,user.description,user.username,user.avatar);

      if (success) {
        emit(UserModifierState(status: UserModifierStatus.successEditingPost));
      }
    } catch (e) {
      emit(UserModifierState(status: UserModifierStatus.errorEditingPost));
    }
  }
}
