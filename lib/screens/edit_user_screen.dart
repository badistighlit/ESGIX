import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/user_modifier/user_modifier_bloc.dart';  // Assurez-vous d'importer le bon bloc
import 'package:projet_esgix/models/user_model.dart';

import '../repositories/user_repository.dart';
import '../services/api_service.dat.dart';

class UserEditScreen extends StatefulWidget {
  final User user;

  const UserEditScreen({super.key, required this.user});

  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username!;
    _descriptionController.text = widget.user.description ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserModifierBloc(repository: UserRepository(ApiService.instance!)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Modifier le Profil')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<UserModifierBloc, UserModifierState>(
            listener: (context, state) {
              if (state.status == UserModifierStatus.successEditingPost) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil mis à jour avec succès')),
                );
                Navigator.pop(context);
              } else if (state.status == UserModifierStatus.errorEditingPost) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Échec de la mise à jour du profil.')),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  state.status == UserModifierStatus.editingPost
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: () {
                      final updatedUser = widget.user.copyWith(
                        username: _usernameController.text,
                        description: _descriptionController.text,
                      );
                      context.read<UserModifierBloc>().add(EditUser(updatedUser));
                    },
                    child: const Text('Enregistrer'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
