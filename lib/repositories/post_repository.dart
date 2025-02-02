
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
}
