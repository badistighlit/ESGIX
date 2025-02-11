part of 'user_modifier_bloc.dart';

sealed class UserModifierEvent {
  final User user;

  UserModifierEvent(this.user);
}



class EditUser extends UserModifierEvent {
  EditUser(super.user);
}