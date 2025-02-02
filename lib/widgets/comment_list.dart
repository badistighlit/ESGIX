import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import 'comment_card.dart';  // Assurez-vous d'importer CommentCard

class CommentList extends StatelessWidget {
  final List<CommentModel> comments;  // La liste des commentaires à afficher

  const CommentList({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return CommentCard(comment: comment);
      },
    );
  }
}
