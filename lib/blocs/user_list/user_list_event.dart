part of 'user_list_bloc.dart';


sealed class UserListEvent {}


class GetPostLikes extends UserListEvent {
  final String idPost;

  GetPostLikes({required this.idPost});
}