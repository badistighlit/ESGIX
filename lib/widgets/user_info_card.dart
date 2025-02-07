import 'package:flutter/material.dart';
import 'package:projet_esgix/models/user_model.dart';

class UserInfoCard extends StatefulWidget {
  const UserInfoCard({super.key, required this.user});

  final User user;

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          'https://static-00.iconduck.com/assets.00/avatar-icon-512x512-gu21ei4u.png',
          width: 100,
          height: 100,
        ),
        Text(
          widget.user.username!,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
