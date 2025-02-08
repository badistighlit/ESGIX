import 'package:flutter/material.dart';
import '../models/auth_user_model.dart';
import '../models/post_model.dart';
import '../screens/CreatePostScreen.dart';
import '../screens/post_detail_screen.dart';
import '../repositories/post_repository.dart';
import '../services/api_service.dat.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final PostRepository postRepository;
  final Function? onPostDeleted;
  final Function? backFromDetails;

  const PostCard({
    Key? key,
    required this.post,
    required this.postRepository,
    this.onPostDeleted,
    this.backFromDetails,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool _likedByUser;
  final PostRepository _postRepository = PostRepository(apiService: ApiService(baseUrl: 'https://esgix.tech'));

  @override
  void initState() {
    super.initState();
    _likedByUser = widget.post.likedByUser;
  }


  Future<void> _toggleLike() async {
    try {
      final liked = await widget.postRepository.likePost(widget.post.id);

      setState(() {

        if (liked) {
          _likedByUser = !_likedByUser;
          if (_likedByUser) {
            widget.post.likesCount++;
          } else {
            widget.post.likesCount--;
          }
        }
      });
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _toggleParams(BuildContext context, Offset offset, String idPost) {
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
              idPost: idPost,
            ),
          ),
        );
        if (edited == true && widget.onPostDeleted != null) {
          widget.onPostDeleted!();
        }
      } else if (value == 'delete') {
        _showDeleteConfirmationDialog(context, idPost);
      }
    });
  }

  void _showDeleteConfirmationDialog(BuildContext context, String idPost) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer ce post ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _postRepository.deletePostById(idPost);

                  Navigator.of(context).pop();

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (widget.onPostDeleted != null) {
                      widget.onPostDeleted!();
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur lors de la suppression: $e'))
                  );
                };
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.backFromDetails != null) {
          widget.backFromDetails!(widget.post.id);
        }
      },
      child: Card(
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
                  if (widget.post.author.id == AuthUser.id)
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        _toggleParams(context, details.globalPosition, widget.post.id);
                      },
                      child: Icon(Icons.settings),
                    ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(widget.post.content),
              if (widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(widget.post.imageUrl!),
                ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Likes: ${widget.post.likesCount}'),
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: _likedByUser ? Colors.red : Colors.grey,
                        ),
                        onPressed: _toggleLike,
                      ),
                    ],
                  ),
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