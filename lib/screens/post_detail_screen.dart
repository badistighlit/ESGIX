import 'package:flutter/material.dart';
import 'package:projet_esgix/models/post_model.dart';
import 'package:projet_esgix/models/comment_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import '../services/api_service.dat.dart';
import '../widgets/comment_list.dart';
import '../widgets/post_card.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Future<Post> _postFuture;
  late Future<List<CommentModel>> _commentsFuture;
  final PostRepository _postRepository = PostRepository(apiService: ApiService(baseUrl: 'https://esgix.tech'));

  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPostAndComments();
  }

  void _loadPostAndComments() {
    setState(() {
      _postFuture = _postRepository.getPostById(widget.postId);
      _commentsFuture = _postRepository.getComments(widget.postId);
    });
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    final imageUrl = _imageUrlController.text.trim().isNotEmpty ? _imageUrlController.text.trim() : null;

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le commentaire ne peut pas être vide.")),
      );
      return;
    }

    try {
      final success = await _postRepository.createComment(content, imageUrl, widget.postId);
      if (success) {
        _commentController.clear();
        _imageUrlController.clear();
        _loadPostAndComments(); // Rafraîchir les commentaires après l'ajout
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Commentaire ajouté avec succès !")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post Details')),
      body: FutureBuilder<Post>(
        future: _postFuture,
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (postSnapshot.hasError) {
            return Center(child: Text('Error: ${postSnapshot.error}'));
          }

          final post = postSnapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostCard(post: post, postRepository: _postRepository),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: "Écrire un commentaire...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        hintText: "Entrer l'URL d'une image (optionnel)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _submitComment,
                      child: Text("Ajouter"),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: FutureBuilder<List<CommentModel>>(
                  future: _commentsFuture,
                  builder: (context, commentSnapshot) {
                    if (commentSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (commentSnapshot.hasError) {
                      return Center(child: Text('Error: ${commentSnapshot.error}'));
                    }

                    final comments = commentSnapshot.data ?? [];

                    if (comments.isEmpty) {
                      return Center(child: Text('Aucun commentaire.'));
                    }

                    return CommentList(comments: comments);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
