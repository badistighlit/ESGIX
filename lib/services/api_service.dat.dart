import 'dart:convert';
import 'dart:developer'; // Pour log

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:projet_esgix/models/user_model.dart';

class ApiService {
  final String baseUrl;
  final http.Client httpClient;

  ApiService({required this.baseUrl, required this.httpClient});

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
}
