import 'package:shared_preferences/shared_preferences.dart';

class LocalDataService {
  static Future<String?> getToken() async {
    SharedPreferences localData = await SharedPreferences.getInstance();

    return localData.getString('token');
  }

  static Future<String?> getAuthUserId() async {
    SharedPreferences localData = await SharedPreferences.getInstance();

    return localData.getString('userId');
  }

  static Future<void> setToken(String token) async {
    SharedPreferences localData = await SharedPreferences.getInstance();

    localData.setString('token', token);
  }

  static Future<void> setAuthUserId(String userId) async {
    SharedPreferences localData = await SharedPreferences.getInstance();

    localData.setString('userId', userId);
  }

  static Future<void> clearToken() async {
    SharedPreferences localData = await SharedPreferences.getInstance();

    localData.remove('token');
  }

  static Future<void> clearAuthUserId() async {
    SharedPreferences localData = await SharedPreferences.getInstance();

    localData.remove('userId');
  }
}