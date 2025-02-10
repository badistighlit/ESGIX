import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/comment_modifier/comment_modifier_bloc.dart';
import 'package:projet_esgix/blocs/user/user_bloc.dart';
import 'package:projet_esgix/models/comment_model.dart';
import 'package:projet_esgix/models/auth_user_model.dart';
import 'package:projet_esgix/repositories/user_repository.dart';
import 'package:projet_esgix/screens/user_profile_screen.dart';
import 'package:projet_esgix/services/api_service.dat.dart';

class CommentCard extends StatefulWidget {
  final CommentModel comment;

  const CommentCard({
    super.key,
    required this.comment,
  });

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
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
                    _buildAvatarImage(),
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
                      _toggleParams(context, details.globalPosition);
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

  void _toggleParams(BuildContext context, Offset offset) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx + 1, offset.dy + 1),
      items: [
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
    ).then((value) {
      if (value == 'delete' && context.mounted) {
        _showDeleteConfirmationDialog(context, context.read<CommentModifierBloc>());
      }
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, CommentModifierBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous vraiment supprimer ce commentaire ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Non'),
            ),
            BlocListener<CommentModifierBloc, CommentModifierState>(
              bloc: bloc,
              listener: (context, state) {
                if (state.status == CommentModifierStatus.successDeletingComment) {
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(content: Text('Commentaire supprimé'))
                  );
                } else if (state.status == CommentModifierStatus.errorDeletingComment) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text('Erreur lors de la suppression: ${state.exception.toString()}'))
                  );
                }
              },
              child: TextButton(
                onPressed: () {
                  bloc.add(DeleteComment(widget.comment));
                },
                child: const Text('Oui'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAvatarImage() {
    return GestureDetector(
      onTap: _navigateToUserPage,
      child: CircleAvatar(
        backgroundImage: widget.comment.author!.avatar != null && widget.comment.author!.avatar!.isNotEmpty
            ? NetworkImage(widget.comment.author!.avatar!)
            : const AssetImage('lib/assets/default_avatar.png') as ImageProvider,
        radius: 20,
      ),
    );
  }

  void _navigateToUserPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RepositoryProvider(
            create: (context) => UserRepository(ApiService.instance!),
            child: BlocProvider<UserBloc>(
              create: (context) => UserBloc(repository: context.read<UserRepository>()),
              child: UserProfileScreen(
                userId: widget.comment.author!.id,
              ),
            ),
          ),
        ));
  }
}