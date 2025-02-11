import 'package:flutter/material.dart';
import 'package:projet_esgix/models/user_model.dart';

import '../models/auth_user_model.dart';
import '../screens/edit_user_screen.dart';

class UserInfoCard extends StatelessWidget {
  final User user;
  final AuthUser authUser;

  const UserInfoCard({super.key, required this.user, required this.authUser});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                'https://static-00.iconduck.com/assets.00/avatar-icon-512x512-gu21ei4u.png',
                width: 100,
                height: 100,
              ),
              SizedBox(width: 10),
              Text(
                user.username!,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),



          //  bouton "Éditer Profil" || à ajouter condition user.id == authUser.id

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserEditScreen(user: user),
                  ),
                );
              },
              child: const Text("Éditer le profil"),
            ),
        ],
      ),
    );
  }
}
