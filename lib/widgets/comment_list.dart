import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import '../repositories/post_repository.dart';
import 'comment_card.dart';

class CommentList extends StatelessWidget {
  final List<CommentModel> comments;
  final PostRepository postRepository;
  final Function? onCommentDeleted;

  const CommentList({
    Key? key,
    required this.comments,
    required this.postRepository,
    this.onCommentDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return CommentCard(
          comment: comment,
          postRepository: postRepository,
          onCommentDeleted: onCommentDeleted,
        );
      },
    );
  }
}
