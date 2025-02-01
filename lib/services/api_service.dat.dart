import 'dart:developer'; // Pour log
import 'package:dio/dio.dart';

import 'package:projet_esgix/models/user_model.dart';

class ApiService {
  static ApiService? _instance;
  final String baseUrl;
  Map<String, String> defaultHeaders;
  late final Dio _httpClient;
  late final String _token;

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

  Future<User> login(String email, String password) async {
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

    _token = response.data['token'];

    return User.fromJson(response.data);
  }

  Future<Register> register(String email, String password, String username, String avatar) async {
    final response = await _httpClient.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'username': username,
        'avatar': avatar
      },
    );
    if (response.statusCode == 200) {
      return Register.fromJson(response.data);
    }

    if (response.statusCode == 400) {
      throw Exception(response.data['message'] ?? 'Unknown error occurred');
    } else {
      throw Exception('Failed to register: ${response.data}');
    }
  }


}
