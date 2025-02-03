import 'package:flutter/material.dart';
import 'package:projet_esgix/models/post_model.dart';
import 'package:projet_esgix/models/comment_model.dart';
import 'package:projet_esgix/repositories/post_repository.dart';
import '../services/api_service.dat.dart';
import '../widgets/comment_list.dart';
import '../widgets/post_card.dart';


class PostDetailScreen extends StatefulWidget {
  final String postId; // ID du post dont vous voulez afficher les détails

  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Future<Post> _postFuture;
  late Future<List<CommentModel>> _commentsFuture;
  final PostRepository _postRepository = PostRepository(apiService: ApiService(baseUrl: 'https://esgix.tech'));

  @override
  void initState() {
    super.initState();
    _postFuture = _postRepository.getPostById(widget.postId);
    _commentsFuture = _postRepository.getComments(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: FutureBuilder<Post>(
        future: _postFuture,
        builder: (context, postSnapshot) {
          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (postSnapshot.hasError) {
            return Center(child: Text('Error: ${postSnapshot.error}'));
          }

          final post = postSnapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              PostCard(post: post, postRepository: _postRepository,),

              Expanded(
                child: FutureBuilder<List<CommentModel>>(
                  future: _commentsFuture,
                  builder: (context, commentSnapshot) {
                    if (commentSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (commentSnapshot.hasError) {
                      return Center(child: Text('Error: ${commentSnapshot.error}'));
                    }

                    final comments = commentSnapshot.data ?? [];

                    if (comments.isEmpty) {
                      return Center(child: Text('No comments yet.'));
                    }

                    return CommentList(comments: comments);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
