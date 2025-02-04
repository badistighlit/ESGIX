import 'package:flutter/material.dart';
import '../repositories/post_repository.dart';

class CreatePostScreen extends StatefulWidget {
  final PostRepository postRepository;

  const CreatePostScreen({Key? key, required this.postRepository}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isSubmitting = false;

  void _submitPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final bool success = await widget.postRepository.createPost(
      _contentController.text,
      _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post créé avec succès !"), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true); // Retour à HomeScreen avec succès
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la création du post."), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: "Contenu", border: OutlineInputBorder()),
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
                decoration: const InputDecoration(labelText: "Image URL (optionnel)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitPost,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text("Publier"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
