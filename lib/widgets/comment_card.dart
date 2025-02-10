import 'package:flutter/material.dart';
import 'package:projet_esgix/screens/create_or_edit_post_screen.dart';
import '../models/comment_model.dart';
import '../models/auth_user_model.dart';
import '../repositories/post_repository.dart';

class CommentCard extends StatefulWidget {
  final CommentModel comment;
  final PostRepository postRepository;
  final Function? onCommentDeleted;

  const CommentCard({
    super.key,
    required this.comment,
    required this.postRepository,
    this.onCommentDeleted,
  });

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  void _toggleParams(BuildContext context, Offset offset, String idComment) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx + 1, offset.dy + 1),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: const [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: const [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete'),
            ],
          ),
        ),
      ],
    ).then((value) async {
      if (value == 'edit') {
        final edited = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePostScreen(
              postRepository: widget.postRepository,
              idPost: idComment,
            ),
          ),
        );
        if (edited == true && widget.onCommentDeleted != null) {
          widget.onCommentDeleted!();
        }
      } else if (value == 'delete') {
        _showDeleteConfirmationDialog(context, idComment);
      }
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, String idComment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous vraiment supprimer ce commentaire ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await widget.postRepository.deletePostById(idComment);
                  Navigator.of(context).pop();

                  if (widget.onCommentDeleted != null) {
                    widget.onCommentDeleted!();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur lors de la suppression: $e'))
                  );
                }
              },
              child: const Text('Oui'),
            ),
          ],
        );
      },
    );
  }

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: widget.comment.author!.avatar != null && widget.comment.author!.avatar!.isNotEmpty
                          ? NetworkImage(widget.comment.author!.avatar!)
                          : const AssetImage('lib/assets/default_avatar.png') as ImageProvider,
                      radius: 20,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      widget.comment.author!.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (widget.comment.author!.id == AuthUser.id)
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      _toggleParams(context, details.globalPosition, widget.comment.id);
                    },
                    child: const Icon(Icons.settings),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),

            if (widget.comment.imageUrl != null && widget.comment.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(widget.comment.imageUrl!),
              ),
            const SizedBox(height: 8.0),

            Text(widget.comment.content),
            const SizedBox(height: 8.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Likes: ${widget.comment.likesCount}'),
                Text('Replies: ${widget.comment.commentsCount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}