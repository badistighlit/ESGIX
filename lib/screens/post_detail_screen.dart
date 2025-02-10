import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_esgix/blocs/comment_list/comment_list_bloc.dart';
import 'package:projet_esgix/blocs/comment_modifier/comment_modifier_bloc.dart';
import 'package:projet_esgix/blocs/post/post_bloc.dart';
import 'package:projet_esgix/exceptions/global/app_exception.dart';
import 'package:projet_esgix/models/comment_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import 'package:projet_esgix/widgets/comment_card.dart';
import 'package:projet_esgix/services/api_service.dat.dart';
import 'package:projet_esgix/widgets/post_card.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPostAndComments();
  }

  void _loadPostAndComments() {
    _loadAllPosts();
    _loadAllComments();
  }

  void _loadAllPosts() => context.read<PostBloc>().add(GetPost(widget.postId));

  void _loadAllComments() => context.read<CommentListBloc>().add(GetAllComments(parentPostId: widget.postId));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.change_circle_rounded),
              onPressed: _loadAllComments,
            ),
          ],
        ),
        body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPostCard(context),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: "Écrire un commentaire...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _imageUrlController,
                        decoration: const InputDecoration(
                          hintText: "Entrer l'URL d'une image (optionnel)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocConsumer<CommentModifierBloc, CommentModifierState>(
                        listener: _onModifierCommentBlocListener,
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () => _onValidate(context),
                            child: const Text("Ajouter"),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: BlocBuilder<CommentListBloc, CommentListState>(
                    builder: (context, state) {
                      return switch (state.status) {
                        CommentListStatus.loading => _showLoading(),
                        CommentListStatus.success => _showSuccess(state.comments, _loadAllComments),
                        CommentListStatus.failure => _showFailure(state.exception!),
                        CommentListStatus.empty => _showEmpty(),
                      };
                    },
                  ),
                ),
            ],
          ),
        ));
      }


  void _onValidate(BuildContext context) {
    final content = _commentController.text.trim();
    final imageUrl = _imageUrlController.text.trim().isNotEmpty ? _imageUrlController.text.trim() : null;

    final comment = CommentModel.copyWith(parentId: widget.postId, content: content, imageUrl: imageUrl);

    context.read<CommentModifierBloc>().add(CreateComment(comment));
  }

  void _onModifierCommentBlocListener(
      BuildContext context,
      CommentModifierState state,
      ) {
    final message = switch (state.status) {
      CommentModifierStatus.successAddingComment => 'Commentaire ajouté avec succès',
      CommentModifierStatus.errorAddingComment => 'Erreur lors de l\'ajout du commentaire : ${state.exception}',
      _ => null,
    };

    if (message == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Widget _buildPostCard(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      if (state.status == PostStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.status == PostStatus.loaded) {
        return PostCard(post: state.post!,);
      }
      return Center(child: Text("Erreur : Error loading post with state ${state.status}"));
    });
  }

  Widget _showLoading() => const Center(child: CircularProgressIndicator());

  Widget _showSuccess(List<CommentModel> comments, Function? _loadAllComments) => ListView.builder(
    itemCount: comments.length,
    itemBuilder: (context, index) {
      final comment = comments[index];
      return CommentCard(
        comment: comment,
        postRepository: PostRepository(apiService: ApiService.instance!),
        onCommentDeleted: _loadAllComments,
      );
    },
  );

  Widget _showFailure(AppException error) => Center(child: Text("Erreur : $error"));

  Widget _showEmpty() => const Center(child: Text("Aucun commentaire disponible."));
}
