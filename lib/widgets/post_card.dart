import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/post/post_bloc.dart';
import 'package:projet_esgix/blocs/post_modifier/post_modifier_bloc.dart';
import 'package:projet_esgix/blocs/user/user_bloc.dart';
import 'package:projet_esgix/repositories/user_repository.dart';
import 'package:projet_esgix/screens/create_or_edit_post_screen.dart';
import 'package:projet_esgix/models/auth_user_model.dart';
import 'package:projet_esgix/models/post_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import 'package:projet_esgix/screens/user_profile_screen.dart';
import 'package:projet_esgix/services/api_service.dat.dart';

import '../blocs/user_list/user_list_bloc.dart';
import '../screens/liked_users_screen.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Function? postDetailsNavigator;

  const PostCard({
    super.key,
    required this.post,
    this.postDetailsNavigator,
  });

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
            if (widget.postDetailsNavigator != null) {
              widget.postDetailsNavigator!(widget.post.id);
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
                          _buildAvatarImage(),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => UserListBloc(repository: context.read<PostRepository>())
                                      ..add(GetPostLikes(idPost: widget.post.id!)),
                                    child: LikedUserScreen(postId: widget.post.id!),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              widget.post.likesCount == 1 ? '${widget.post.likesCount} like' : '${widget.post.likesCount} likes',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
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
    final menuContext = Navigator
        .of(context)
        .context;

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
        create: (context) =>
            PostModifierBloc(repository: context.read<PostRepository>()),
        child: CreatePostScreen(
          post: widget.post,
        ),
      ),
    );

    showMenu(
      context: menuContext,
      position: RelativeRect.fromLTRB(
          offset.dx, offset.dy, offset.dx + 1, offset.dy + 1),
      items: items,
    ).then((value) async {
      if (value == 'edit' && context.mounted) {
        final edited = await Navigator.push(
          menuContext,
          MaterialPageRoute(
              builder: (context) => createPostScreen
          ),
        );
        if (edited == true && context.mounted) {
          context.read<PostBloc>().add(GetPost(idPost));
        }
      } else if (value == 'delete' && context.mounted) {
        _showDeleteConfirmationDialog(
            context, idPost, context.read<PostBloc>());
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')));
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String idPost,
      bloc) {
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
            BlocListener<PostBloc, PostState>(
              bloc: bloc,
              listener: (context, state) {
                if (state.status == PostStatus.deleted) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text('Post supprimé'))
                  );
                  Navigator.of(dialogContext).pop();
                } else if (state.status == PostStatus.error) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text(
                          'Erreur lors de la suppression: ${state.exception
                              .toString()}'))
                  );
                }
              },
              child: TextButton(
                onPressed: () {
                  context.read<PostBloc>().add(DeletePost(widget.post.id!));
                },
                child: Text('Oui'),
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
        radius: 20,
        backgroundImage: widget.post.author?.avatar != null && widget.post.author!.avatar!.isNotEmpty
            ? NetworkImage(widget.post.author!.avatar!)
            : const AssetImage('lib/assets/default_avatar.png') as ImageProvider,
        onBackgroundImageError: (_, __) => debugPrint("Erreur de chargement de l'image"),
        child: (widget.post.author?.avatar == null || widget.post.author!.avatar!.isEmpty)
            ? const Icon(Icons.person) // Icône par défaut si pas d'avatar
            : null,
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
              userId: widget.post.author!.id,
            ),
          ),
        ),
    ));
  }
}

