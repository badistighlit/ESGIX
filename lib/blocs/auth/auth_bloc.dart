import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/auth_user_model.dart';
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<Login>(_onLogin);
    on<Register>(_onRegister);
  }

  void _onLogin(Login event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.login(event.email, event.password);

      emit(AuthSuccess(AuthUser.username!));
    } catch (e) {
      emit(AuthFailure("Échec de la connexion : ${e.toString()}"));
    }
  }

  void _onRegister(Register event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.register(event.email, event.password, event.username, event.avatar);

      emit(AuthSuccess(event.username));
        } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
