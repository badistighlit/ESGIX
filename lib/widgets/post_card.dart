import 'package:flutter/material.dart';

import '../models/post_model.dart';


class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.author.username, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            if (post.imageUrl != '' ) Image.network(post.imageUrl!),
            SizedBox(height: 8.0),
            Text(post.content),
            SizedBox(height: 8.0),
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
    );
  }
}
