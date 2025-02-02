part of 'user_bloc.dart';

sealed class UserEvent {}

class GetUser extends UserEvent {
  final String id;

  GetUser(this.id);
}
