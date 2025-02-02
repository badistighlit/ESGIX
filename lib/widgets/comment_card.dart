import 'package:flutter/material.dart';
import '../models/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;

  const CommentCard({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (comment.author.avatar != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(comment.author.avatar!),
                  ),
                SizedBox(width: 8.0),
                Text(comment.author.username, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8.0),

            if (comment.imageUrl != null && comment.imageUrl != '')
              Image.network(comment.imageUrl!),
            SizedBox(height: 8.0),

            Text(comment.content),
            SizedBox(height: 8.0),

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
