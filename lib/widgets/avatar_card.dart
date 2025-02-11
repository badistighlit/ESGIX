import 'package:flutter/material.dart';
import 'package:projet_esgix/models/comment_model.dart';

class UserAvatarCard extends StatelessWidget {
  final Author user;

  const UserAvatarCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
            ? NetworkImage(user.avatar!)
            : const AssetImage('lib/assets/default_avatar.png') as ImageProvider,
        radius: 20,
      ),
      title: Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
