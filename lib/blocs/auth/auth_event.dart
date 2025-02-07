import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Login extends AuthEvent {
  final String email;
  final String password;

  Login({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {}

class LogOut extends AuthEvent {}

class Register extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String avatar;

  Register({required this.email, required this.password, required this.username, required this.avatar});

  @override
  List<Object> get props => [email, password, username, avatar];
}