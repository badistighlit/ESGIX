import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<Login>(_onLogin);
    on<Register>(_onRegister);
    on<AppStarted>(_onAppStarted);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onLogin(Login event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(event.email, event.password);
      if (user.token.isNotEmpty) {
        emit(AuthSuccess(user.username));
      } else {
        emit(AuthFailure("Échec de la connexion : token vide"));
      }
    } catch (e) {
      emit(AuthFailure("Échec de la connexion : ${e.toString()}"));
    }
  }

  void _onRegister(Register event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final register = await authRepository.register(event.email, event.password, event.username, event.avatar);
      emit(AuthSuccess(register.username));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Vérifier si l'utilisateur a un token valide
      final currentUser = await authRepository.getCurrentUser();
      if (currentUser != null) {
        emit(AuthSuccess(currentUser.username));
      } else {
        emit(const AuthInitial());
      }
    } catch (e) {
      emit(const AuthInitial());
    }
  }
  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }


}