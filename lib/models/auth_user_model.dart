import 'package:projet_esgix/models/user_model.dart';

class AuthUser {
  static AuthUser? _instance;
  String _bearerToken;
  String _id;
  String _username;
  String _avatar;

  AuthUser._({
    required String bearerToken,
    required String id,
    required String username,
    required String avatar,
  }): _bearerToken = bearerToken,
        _id = id,
        _username = username,
        _avatar = avatar;


  factory AuthUser({
    required String id,
    required String username,
    required String avatar,
    required String bearerToken
  }) {

    _instance ??= AuthUser._(
      id: id,
      username: username,
      avatar: avatar,
      bearerToken: bearerToken,
    );

    return _instance!;
  }

  static String? get bearerToken => _instance?._bearerToken;
  static String? get bearerTokenHeaderValue => "Bearer ${_instance!._bearerToken}";
  static String? get id => _instance?._id;
  static String? get username => _instance?._username;
  static String? get avatar => _instance?._avatar;

  factory AuthUser.fromJson(Map<String, dynamic> data) {
    final userData = data['record'];

    return AuthUser(
      id: userData['id'],
      username: userData['username'],
      avatar: userData['avatar'],
      bearerToken: data['token']
    );
  }

  factory AuthUser.fromUser(User user, String bearerToken) {
      return AuthUser(
          id: user.id!,
          username: user.username!,
          avatar: user.avatar!,
          bearerToken: bearerToken,
      );
  }

  static bool isLoggedIn() => AuthUser.bearerToken != null && AuthUser.bearerToken!.isNotEmpty;

  static void clearCurrentInstance() {
    _instance = null;
  }
}
