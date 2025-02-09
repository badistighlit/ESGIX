import 'dart:core';
import 'package:dio/dio.dart';
import 'package:projet_esgix/models/auth_user_model.dart';

class ApiService {
  static ApiService? _instance;
  final String baseUrl;
  Map<String, String> defaultHeaders;
  late final Dio _httpClient;

  ApiService._({required this.baseUrl, this.defaultHeaders = const {}}) {
    _httpClient = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: defaultHeaders,
    ));
  }

  factory ApiService({required String baseUrl, Map<String, String> defaultHeaders = const {}}) {
    _instance ??= ApiService._(baseUrl: baseUrl, defaultHeaders: defaultHeaders);
    return _instance!;
  }

  static ApiService? get instance => _instance;

  Future<void> login(String email, String password) async {
    try {
      final response = await _httpClient.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password
        },
      );

      if (response.statusCode == 200) {
        AuthUser.fromJson(response.data);
      } else {
        throw Exception('Failed to login: ${response.data}');
      }
    } catch (e) {
      throw Exception('Login error: ${e.toString()}');
    }
  }

  Future<void> register(String email, String password, String username, [String? avatar]) async {
    try {
      final data = {'email': email, 'password': password, 'username': username};
      if (avatar != null) {
        data['avatar'] = avatar;
      }

      final response = await _httpClient.post('/auth/register', data: data);

      if (response.statusCode != 200) {
        throw Exception(response.data['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      throw Exception('Registration error: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getUserById(String id, [String? token]) async {
    try {
      final response = await _httpClient.get(
        '/users/$id',
        options: Options(headers: {'Authorization': token ?? AuthUser.bearerTokenHeaderValue ?? ''}),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('Failed to fetch user: ${response.data}');
    } catch (e) {
      throw Exception('Get user error: ${e.toString()}');
    }
  }
//posts
  //get posts
  Future<List<Map<String, dynamic>>> fetchPosts({int page = 0, int offset = 100}) async {
    try {
      final response = await _httpClient.get(
        '/posts',
        queryParameters: {'page': page, 'offset': offset},
        options: Options(headers: _getHeaders()),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
      throw Exception('Failed to load posts: ${response.statusCode}');
    } catch (e) {
      throw Exception('Fetch posts error: ${e.toString()}');
    }
  }


  // get post by id
  Future<Map<String, dynamic>> fetchPostById(String idPost) async {
    try {
      final response = await _httpClient.get(
        '/posts/$idPost',
        options: Options(headers: _getHeaders()),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      }
      throw Exception('Failed to load post: ${response.statusCode}');
    } catch (e) {
      throw Exception('Fetch post error: ${e.toString()}');
    }
  }

// Like post
  Future<bool> likePost (String idPost) async {
    try{
      final response = await _httpClient.post('/likes/$idPost',options:  Options(headers: _getHeaders()),);
      if (response.statusCode == 200 ||response.statusCode == 201 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to like a post : ${response.statusCode}');
      }

    }
        catch(e)
    {throw Exception("Liking post error : ${e.toString()}");}

  }

  //create post
  Future<bool> createPost(String content, String? imageUrl) async {
    try {
      final response = await _httpClient.post(
        '/posts',
        options: Options(headers: _getHeaders()),
        data: {
          'content': content,
          if (imageUrl != null) 'imageUrl': imageUrl,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Creating post error: ${e.toString()}");
    }
  }

  Future<bool> updatePost(String idPost, String content, String? imageUrl) async {
    try {
      final response = await _httpClient.put(
        '/posts/$idPost',
        options: Options(headers: _getHeaders()),
        data: {
          'content': content,
          if (imageUrl != null) 'imageUrl': imageUrl,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Creating post error: ${e.toString()}");
    }
  }

  //comments
  Future<List<Map<String, dynamic>>> fetchComments(String idParent) async {
    try {
      final response = await _httpClient.get(
        '/posts',
        queryParameters: {'parent': idParent},
        options: Options(headers: _getHeaders()),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
      throw Exception('Failed to load comments: ${response.statusCode}');
    } catch (e) {
      throw Exception('Fetch posts error: ${e.toString()}');
    }
  }

  Future<bool> createComment(String content, String? imageUrl, String idParent) async {
    try {
      final response = await _httpClient.post(
        '/posts',
        options: Options(headers: _getHeaders()),
        data: {
          'content': content,
          if (imageUrl != null) 'imageUrl': imageUrl,
          'parent' : idParent
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Creating comment error: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> fetchUserPosts(String userId, {bool liked = false, int page = 0, int offset = 0}) async {
    try {
      final response = await _httpClient.get(
          '/user/$userId/${liked ? 'likes' : 'posts'}',
          options: Options(headers: _getHeaders()),
          queryParameters: {
            'page': page,
            'offset': offset,
          }
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      return Map.of({});
    } catch (e) {
      throw Exception("Error fetching posts for user: ${e.toString()}");
    }
  }

  Future<void> deletePostById(String idPost) async {
    try {
      final response = await _httpClient.delete(
        '/posts/$idPost',
        options: Options(headers: _getHeaders()),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('delete post error: ${e.toString()}');
    }
  }

  void logout() {
    AuthUser.clearCurrentInstance();
  }

  Map<String, String> _getHeaders() {
    return {
      if (AuthUser.bearerTokenHeaderValue != null) 'Authorization': AuthUser.bearerTokenHeaderValue!,
      ...defaultHeaders,
    };
  }
}
