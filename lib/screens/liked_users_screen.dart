import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/user_list/user_list_bloc.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import 'package:projet_esgix/services/api_service.dat.dart';

import '../models/comment_model.dart';
class LikedUserScreen extends StatefulWidget {
  final String postId;

  const LikedUserScreen({super.key, required this.postId});

  @override
  _LikedUserScreenState createState() => _LikedUserScreenState();
}

class _LikedUserScreenState extends State<LikedUserScreen> {
  late final PostRepository _postRepository;
  late final UserListBloc _userListBloc;

  @override
  void initState() {
    super.initState();
    _postRepository = PostRepository(apiService: ApiService.instance!);
    _userListBloc = UserListBloc(repository: _postRepository);
    _userListBloc.add(GetPostLikes(idPost: widget.postId));
  }

  @override
  void dispose() {
    _userListBloc.close();
    super.dispose();
  }


  // à debugger
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personnes ayant liké")),
      body: BlocProvider<UserListBloc>(
        create: (_) => _userListBloc,
        child: BlocBuilder<UserListBloc, UserListState>(
          builder: (context, state) {
            if (state.status == UserListStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == UserListStatus.failure) {
              return Center(child: Text("Erreur : ${state.exception}"));
            } else if (state.status == UserListStatus.empty) {
              return const Center(child: Text("Aucun like pour ce post c'est triste"));
            } else {
              return _buildUserList(state.users);
            }
          },
        ),
      ),
    );
  }









  Widget _buildUserList(List<Author> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
                ? NetworkImage(user.avatar!)
                : const AssetImage('lib/assets/default_avatar.png') as ImageProvider,
          ),
          title: Text(user.username),
        );
      },
    );
  }
}
