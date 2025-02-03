import 'package:flutter/material.dart';
import '../models/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;

  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Affichage de l'avatar avec une image par défaut si null ou vide
                CircleAvatar(
                  backgroundImage: comment.author.avatar != null && comment.author.avatar!.isNotEmpty
                      ? NetworkImage(comment.author.avatar!)
                      : const AssetImage('lib/assets/default_avatar.png') as ImageProvider,
                  radius: 20, // Taille de l'avatar
                ),
                const SizedBox(width: 8.0),
                // Affichage du nom de l'auteur du commentaire
                Text(
                  comment.author.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8.0),

            // Affichage de l'image du commentaire si elle existe
            if (comment.imageUrl != null && comment.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(comment.imageUrl!),
              ),
            const SizedBox(height: 8.0),

            Text(comment.content),
            const SizedBox(height: 8.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Likes: ${comment.likesCount}'),
                Text('Replies: ${comment.commentsCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
