import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/post_modifier/post_modifier_bloc.dart';
import 'package:projet_esgix/models/post_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';

class CreatePostScreen extends StatefulWidget {
  final PostRepository postRepository;
  final String? idPost;
  final Post? post;

  const CreatePostScreen({super.key, required this.postRepository, this.idPost, this.post});

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    if (widget.post != null) {
      setState(() {
        _contentController.text = widget.post?.content ?? "";
        _imageUrlController.text = widget.post?.imageUrl ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              widget.post != null ? "Modifier le Post" : "Créer un Post"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: "Contenu",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le contenu est obligatoire.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: "Image URL (optionnel)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                BlocConsumer<PostModifierBloc, PostModifierState>(
                  listener: _onModifierPostBlocListener,
                  builder: (context, state) {
                    final editing = state.status == PostModifierStatus.editingPost;
                    final adding = state.status == PostModifierStatus.addingPost;
                    final loading = editing || adding;

                    return _buildButton(context, loading: loading);
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildButton (BuildContext context, {bool loading = false}) {
    if (loading) return const CircularProgressIndicator();
    return ElevatedButton(
      onPressed: _isSubmitting ? null : () => _onValidate(context),
      child: _isSubmitting
          ? const CircularProgressIndicator()
          : Text(isPostUpdate() ? "Modifier" : "Publier"),
    );
  }

  void _onModifierPostBlocListener(
      BuildContext context,
      PostModifierState state,
      ) {
    final message = switch (state.status) {
      PostModifierStatus.successAddingPost => 'Post ajouté avec succès',
      PostModifierStatus.successEditingPost => 'Post modifié avec succès',
      PostModifierStatus.errorAddingPost => 'Erreur lors de l\'ajout du post : ${state.exception}',
      PostModifierStatus.errorEditingPost => 'Erreur lors de la modification du post : ${state.exception}',
      _ => null,
    };

    if (message == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void _onValidate(BuildContext context) {
    if (_isSubmitting) return;

    final content = _contentController.text;
    final imageUrl = _imageUrlController.text;

    final post = switch (isPostUpdate()) {
      true => widget.post?.copyWith(id: widget.post!.id!, content: content, imageUrl: imageUrl),
      false => Post(content: content, imageUrl: imageUrl),
    };

    if (post == null) return;

    final event = switch (isPostUpdate()) {
      true => EditPost(post),
      false => CreatePost(post),
    };

    context.read<PostModifierBloc>().add(event);
  }

  bool isPostUpdate() => widget.post != null;
}
