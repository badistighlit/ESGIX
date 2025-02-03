import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../screens/post_detail_screen.dart'; // Assurez-vous d'importer l'écran de détails

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(postId: post.id), // Passez l'ID du post au PostDetailScreen
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

                  CircleAvatar(
                    backgroundImage: post.author.avatar != null && post.author.avatar!.isNotEmpty
                        ? NetworkImage(post.author.avatar!)
                        : const AssetImage('lib/assets/default_avatar.png') as ImageProvider,
                    radius: 20,
                  ),
                  const SizedBox(width: 10),

                  Text(
                    post.author.username,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(post.imageUrl!),
                ),
              const SizedBox(height: 8.0),
              Text(post.content),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Likes: ${post.likesCount}'),
                  Text('Comments: ${post.commentsCount}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
