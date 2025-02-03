import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../screens/post_detail_screen.dart'; // Assurez-vous d'importer l'écran de détails
import '../repositories/post_repository.dart'; // Importer le repository

class PostCard extends StatefulWidget {
  final Post post;
  final PostRepository postRepository; // Ajout du repository pour liker le post

  const PostCard({Key? key, required this.post, required this.postRepository}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool _likedByUser; // Variable d'état pour suivre le like

  @override
  void initState() {
    super.initState();
    _likedByUser = widget.post.likedByUser; // Initialisation avec l'état du like actuel
  }

  // Méthode pour gérer le "like" ou "unlike" du post
  Future<void> _toggleLike() async {
    try {
      final liked = await widget.postRepository.likePost(widget.post.id);

      setState(() {
        // Si l'opération a réussi, inverse l'état du like
        if (liked) {
          _likedByUser = !_likedByUser; // Inverse l'état du like
          if (_likedByUser) {
            widget.post.likesCount++; // Si l'utilisateur a liké, on augmente le count
          } else {
            widget.post.likesCount--; // Sinon, on décrémente le count
          }
        }
      });
    } catch (e) {
      // Affiche un message d'erreur en cas d'échec
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(postId: widget.post.id), // Passez l'ID du post au PostDetailScreen
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar de l'auteur
                  CircleAvatar(
                    backgroundImage: widget.post.author.avatar != null && widget.post.author.avatar!.isNotEmpty
                        ? NetworkImage(widget.post.author.avatar!)
                        : const AssetImage('lib/assets/default_avatar.png') as ImageProvider,
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.post.author.username,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              // Image du post (si elle existe)
              if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.post.imageUrl!),
                ),
              const SizedBox(height: 8.0),
              Text(widget.post.content),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nombre de likes avec l'icône du cœur
                  Row(
                    children: [
                      Text('Likes: ${widget.post.likesCount}'),
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: _likedByUser ? Colors.red : Colors.grey, // Couleur du cœur (rouge si liké, gris sinon)
                        ),
                        onPressed: _toggleLike, // Appel à la méthode pour liker ou unliker
                        splashColor: Colors.transparent, // Enlever l'animation de splash
                        highlightColor: Colors.transparent, // Enlever l'animation de surbrillance
                      ),
                    ],
                  ),
                  // Nombre de commentaires
                  Text('Comments: ${widget.post.commentsCount}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
