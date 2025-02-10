import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/post/post_bloc.dart';
import 'package:projet_esgix/blocs/post_list/post_list_bloc.dart';
import 'package:projet_esgix/blocs/post_modifier/post_modifier_bloc.dart';
import 'package:projet_esgix/screens/create_or_edit_post_screen.dart';
import 'package:projet_esgix/models/auth_user_model.dart';
import 'package:projet_esgix/models/post_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import 'package:projet_esgix/services/api_service.dat.dart';

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

  @override
  void initState() {
    super.initState();
    _likedByUser = widget.post.likedByUser!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
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
                            backgroundImage: widget.post.author!.avatar !=
                                null && widget.post.author!.avatar!.isNotEmpty
                                ? NetworkImage(widget.post.author!.avatar!)
                                : const AssetImage(
                                'lib/assets/default_avatar.png') as ImageProvider,
                            radius: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.post.author!.username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      if (widget.post.author!.id == AuthUser.id)
                        GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            _toggleParams(context, details.globalPosition,
                                widget.post.id!);
                          },
                          child: Icon(Icons.settings),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(widget.post.content),
                  if (widget.post.imageUrl != null &&
                      widget.post.imageUrl!.isNotEmpty)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(widget.post.imageUrl!),
                      ),
                    ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: _likedByUser ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleLike(context, widget.post.id!),
                          ),
                          Text(widget.post.likesCount == 1 ? '${widget.post
                              .likesCount} like' : '${widget.post
                              .likesCount} likes'),
                        ],
                      ),
                      Text(widget.post.commentsCount == 1 ? '${widget.post
                          .commentsCount} comment ' : '${widget.post
                          .commentsCount} comments'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleParams(BuildContext context, Offset offset, String idPost) {
    final menuContext = Navigator.of(context).context;

    final items = [
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
    ];

    final createPostScreen = RepositoryProvider(
      create: (context) => PostRepository(apiService: ApiService.instance!),
      child: BlocProvider<PostModifierBloc>(
        create: (context) => PostModifierBloc(repository: context.read<PostRepository>()),
        child: CreatePostScreen(
          postRepository: context.read<PostRepository>(),
          post: widget.post,
        ),
      ),
    );

    showMenu(
      context: menuContext,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx + 1, offset.dy + 1),
      items: items,
    ).then((value) async {
      if (value == 'edit' && context.mounted) {
        final edited = await Navigator.push(
          menuContext,
          MaterialPageRoute(
            builder: (context) => createPostScreen
          ),
        );
        if (edited == true && widget.onPostDeleted != null && context.mounted) {
          context.read<PostBloc>().add(GetPost(idPost));
        }
      } else if (value == 'delete' && context.mounted) {
        _showDeleteConfirmationDialog(context, idPost);
      }
    });
  }

  void _toggleLike(BuildContext context, String postId) {
    try {
      context.read<PostBloc>().add(LikePost(postId));

      setState(() {
        _likedByUser = !_likedByUser;
        if (_likedByUser) {
          widget.post.likesCount = widget.post.likesCount! + 1;
        } else {
          widget.post.likesCount = widget.post.likesCount! - 1;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String idPost) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer ce post ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Non'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  context.read<PostBloc>().add(DeletePost(idPost));

                  Navigator.of(dialogContext).pop();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<PostListBloc>().add(GetAllPosts());
                  });

                } catch (e) {
                  log("$e");
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text('Erreur lors de la suppression: $e'))
                  );
                }
              },
              child: Text('Oui'),
            ),
          ],
        );
      },
    );
  }
}