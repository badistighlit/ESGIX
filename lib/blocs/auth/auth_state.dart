import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
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

  @override
  List<Object?> get props => [username];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class RegisterFailure extends AuthState {
  final String error;

  const RegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}



