import 'dart:developer';

import 'package:projet_esgix/models/comment_model.dart';

import '../models/post_model.dart';
import '../services/api_service.dat.dart';

class PostRepository {
  final ApiService apiService;

  PostRepository({required this.apiService});

  Future<List<Post>> getPosts({int page = 0, int offset = 100}) async {
    try {
      final postsJson = await apiService.fetchPosts(page: page, offset: offset);
      return postsJson.map((json) => Post.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<List<CommentModel>> getComments(String idParent) async {
    try {
      final postsJson = await apiService.fetchComments(idParent);
      final mapped = postsJson.map((json) => CommentModel.fromJson(json)).toList();
      return mapped;
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }


Future<Post> getPostById(String idPost) async {
    try {
      final postJson = await apiService.fetchPostById(idPost);
      final mapped = Post.fromJson(postJson);
      return mapped;
    } catch (e) {
      throw Exception('Failed to fetch post by ID: $e');
    }
  }


Future<bool> createPost(String content, String? imageUrl) async {
  try {
    final response = await apiService.createPost(content,imageUrl);
    return response;
  }
  catch(e)
  {  throw Exception('Failed to create post : $e');}
}

  Future<bool> updatePost (String idPost, String content, String? imageUrl) async {
    try {
      final response = await apiService.updatePost(idPost, content, imageUrl);
      return response;
    }
    catch(e)
    {  throw Exception('Failed to update post : $e');}
  }

Future <bool> likePost (String idPost) async {
    try {
      final response = await apiService.likePost(idPost);
      return response;
    }
        catch(e)
  {  throw Exception('Failed to like post : $e');}
}


  Future<bool> createComment(String content, String? imageUrl, String idParent) async {
    try {
      final response = await apiService.createComment(content,imageUrl,idParent);
      return response;
    }
    catch(e)
    {  throw Exception('Failed to create comment : $e');}
  }

  Future<List<Post>> getUserPosts(String userId, {bool liked = false, int page = 0, int offset = 0}) async {
    try {
      Map<String, dynamic> postsJson = await apiService.fetchUserPosts(
          userId, liked: liked, page: page, offset: offset);

      return List.of(postsJson['data'])
          .map((json) => Post.fromJson(json))
          .toList();
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<bool> deletePostById(String idPost) async {
    try {
      await apiService.deletePostById(idPost);
      return true;
    } catch (e) {
      throw Exception('Failed to delete post by ID: $e');
    }
  }
}
