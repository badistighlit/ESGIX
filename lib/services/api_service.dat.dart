import 'dart:async';
import 'package:dio/dio.dart';
import 'package:projet_esgix/models/auth_user_model.dart';
import 'package:projet_esgix/models/user_model.dart';

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

  Future<AuthUser> login(String email, String password) async {
    try {
      final response = await _httpClient.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return AuthUser.fromJson(response.data);
      }
      throw Exception('Failed to login: ${response.data}');
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

  Future<User> getUserById(String id) async {
    try {
      final response = await _httpClient.get(
        '/users/$id',
        options: Options(headers: {'Authorization': AuthUser.bearerTokenHeaderValue ?? ''}),
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      throw Exception('Failed to fetch user: ${response.data}');
    } catch (e) {
      throw Exception('Get user error: ${e.toString()}');
    }
  }
//posts
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

  Future<Map<String, dynamic>> fetchPostById(String idpost) async {
    try {
      final response = await _httpClient.get(
        '/posts/$idpost',
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
