import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/auth_user_model.dart';
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository): super (const AuthState()) {
    on<AppStarted>(_loadCurrentUser);
    on<Login>(_onLogin);
    on<Register>(_onRegister);
    on<LogOut>(_logOut);
  }

  void _logOut(LogOut event, Emitter<AuthState> emit) async {
    await authRepository.logOut();
    AuthUser.clearCurrentInstance();
  }

  void _loadCurrentUser(AppStarted event, Emitter<AuthState> emit) async {
    final bool loaded = await authRepository.loadCurrentUser();

    if (loaded) {
      emit(AuthSuccess(AuthUser.username!));
    }
  }

  void _onLogin(Login event, Emitter<AuthState> emit) async {
    try {
      await authRepository.login(event.email, event.password);

      emit(AuthSuccess(AuthUser.username!));
    } catch (e) {
      emit(AuthFailure("Échec de la  connexion : ${e.toString()}"));
    }
  }

  void _onRegister(Register event, Emitter<AuthState> emit) async {
    try {
      await authRepository.register(event.email, event.password, event.username, event.avatar);

      emit(AuthSuccess(event.username));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}