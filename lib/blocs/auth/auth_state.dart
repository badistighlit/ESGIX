class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String username;

  const AuthSuccess(this.username);
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);
}

class RegisterFailure extends AuthState {
  final String error;

  const RegisterFailure(this.error);
}



