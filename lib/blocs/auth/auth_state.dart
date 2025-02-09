enum AuthStatus {
  loadingCurrentUser,
  currentUserNotLoaded,
  loginFailure,
  registerFailure,
  success,
}

class AuthState {
  final AuthStatus status;
  final String? username;
  final String? error;

  const AuthState({required this.status, this.username, this.error});

  static AuthState copyWith({required AuthStatus status, String? username, String? error}) {
    return AuthState(
      status: status,
      username: username,
      error: error,
    );
  }
}

// class AuthInitial extends AuthState {
//   const AuthInitial();
// }
//
// class AuthLoading extends AuthState {
//   const AuthLoading();
// }
//
// class AuthSuccess extends AuthState {
//   final String username;
//
//   const AuthSuccess(this.username);
// }
//
// class AuthFailure extends AuthState {
//   final String error;
//
//   const AuthFailure(this.error);
// }
//
// class RegisterFailure extends AuthState {
//   final String error;
//
//   const RegisterFailure(this.error);
// }



