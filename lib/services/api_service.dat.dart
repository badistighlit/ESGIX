import 'dart:convert';
import 'dart:developer'; // Pour log

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:projet_esgix/models/user_model.dart';

import '../models/post_model.dart';
class ApiService {
  final String baseUrl;
  final http.Client httpClient;
  String? _token;
  String apiKey = dotenv.get('API_KEY');

  ApiService({required this.baseUrl, required this.httpClient});

  void setToken(String token) {
    _token = token;
  }

  Future<Register> register(String email, String password, String username, String avatar) async {
    String apiKey = dotenv.get('API_KEY');
    Map<String, String> headers = {
      'x-api-key': apiKey,
      'Content-Type': 'application/json'
    };
    String body = jsonEncode({'email': email, 'password': password, 'username': username, 'avatar': avatar});

    final response = await httpClient.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      return Register.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      var errorMessage = json.decode(response.body)['message'] ?? 'Unknown error occurred';
      throw Exception(errorMessage);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<User> login(String email, String password) async {
    String apiKey = dotenv.get('API_KEY');
    Map<String, String> headers = {
      'x-api-key': apiKey,
      'Content-Type': 'application/json'
    };
    String body = jsonEncode({'email': email, 'password': password});

    final response = await httpClient.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPosts({int page = 0, int offset = 100}) async {
    final url = Uri.parse('$baseUrl/posts?page=$page&offset=$offset');

    final headers = {
      'x-api-key': apiKey,
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };

    final response = await httpClient.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }

  Future<User> getUserInfo(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    final response = await httpClient.get(
      url,
      headers: {
        'x-api-key': apiKey,
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get user info');
    }
  }
}

