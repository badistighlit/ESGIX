import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../screens/post_detail_screen.dart'; // Assurez-vous d'importer l'écran de détails
import '../repositories/post_repository.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final PostRepository postRepository;

  const PostCard({Key? key, required this.post, required this.postRepository}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool _likedByUser;

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(postId: widget.post.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Avatar
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
              const SizedBox(height: 8.0),

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
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
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
