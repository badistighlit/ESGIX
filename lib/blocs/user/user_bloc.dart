import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/exceptions/global/app_exception.dart';
import 'package:projet_esgix/models/user_model.dart';
import 'package:projet_esgix/repositories/user_repository.dart';

part "user_event.dart";
part "user_state.dart";

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository repository;

  UserBloc({required this.repository}) : super(const UserState()) {
    on<GetUser>((event, emit) async {
      try {
        final user = await repository.getUserById(event.id);

        emit(state.copyWith(status: UserStateStatus.success, user: user));
      } catch (e) {
        emit(state.copyWith(status: UserStateStatus.failure));
        throw AppException.from(e);
      }
    });
  }
}