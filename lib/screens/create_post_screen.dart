// CreatePostScreen.dart
import 'package:flutter/material.dart';
import '../repositories/post_repository.dart';
import '../models/post_model.dart';

class CreatePostScreen extends StatefulWidget {
  final PostRepository postRepository;
  final String? idPost;

  const CreatePostScreen({Key? key, required this.postRepository, this.idPost}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isSubmitting = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.idPost != null) {
      _loadPost();
    }
  }

  Future<void> _loadPost() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final post = await widget.postRepository.getPostById(widget.idPost!);
      setState(() {
        _contentController.text = post.content;
        // Si imageUrl est ' ', c'est qu'il n'y a pas d'image
        _imageUrlController.text = post.imageUrl == ' ' ? '' : (post.imageUrl ?? '');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement du post: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      bool success;
      final String? imageUrl = _imageUrlController.text.isEmpty ? ' ' : _imageUrlController.text;

      if (widget.idPost != null) {
        success = await widget.postRepository.updatePost(
          widget.idPost!,
          _contentController.text,
          imageUrl,
        );
      } else {
        success = await widget.postRepository.createPost(
          _contentController.text,
          imageUrl,
        );
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.idPost != null ? "Post modifié avec succès !" : "Post créé avec succès !"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception("Opération échouée");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.idPost != null ? "Erreur lors de la modification du post." : "Erreur lors de la création du post."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.idPost != null ? "Modifier le Post" : "Créer un Post"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitPost,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : Text(widget.idPost != null ? "Modifier" : "Publier"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}