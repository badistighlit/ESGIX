import 'dart:async';
import 'package:dio/dio.dart';

import 'package:projet_esgix/models/auth_user_model.dart';
import 'package:projet_esgix/models/user_model.dart';

class ApiService {
  static ApiService? _instance;
  final String baseUrl;
  Map<String, String> defaultHeaders;
  late final Dio _httpClient;

  ApiService._({required this.baseUrl, this.defaultHeaders = const {}})
  {
    _httpClient = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: defaultHeaders,
    ));
  }

  factory ApiService({required baseUrl, defaultHeaders = const {}})
  {
    _instance ??= ApiService._(baseUrl: baseUrl, defaultHeaders: defaultHeaders);

    return _instance!;
  }

  Future<void> login(String email, String password) async {
    final response = await _httpClient.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to login: ${response.data}');
    }

    AuthUser.fromJson(response.data);
  }

  Future<void> register(String email, String password, String username, [String? avatar]) async {
    final data = {
      'email': email,
      'password': password,
      'username': username,
    };

    if (avatar != null) {
      data['avatar'] = avatar;
    }

    final response = await _httpClient.post(
      '/auth/register',
      data: data,
    );
    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 400) {
      throw Exception(response.data['message'] ?? 'Unknown error occurred');
    } else {
      throw Exception('Failed to register: ${response.data}');
    }
  }

  Future<User> getUserById(String id) async {
    final response = await _httpClient.get(
        '/users/$id',
      options: Options(headers: {
        'Authorization' : AuthUser.bearerTokenHeaderValue,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch userById: ${response.data}');
    }

    return User.fromJson(response.data);
  }
}
