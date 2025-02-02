import 'package:flutter/material.dart';
import '../models/post_model.dart';
import 'post_card.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;
  final bool isLoading;

  const PostList({Key? key, required this.posts, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (posts.isEmpty) {
      return const Center(child: Text("Aucun post disponible."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(post: posts[index]);
      },
    );
  }
}
