class AuthUser {
  static AuthUser? _instance;
  final String _bearerToken;
  final String _id;
  final String _username;
  final String _email;
  final String _avatar;

  AuthUser._({
    required String bearerToken,
    required String id,
    required String username,
    required String email,
    required String avatar,
  }): _bearerToken = bearerToken,
        _id = id,
        _username = username,
        _email = email,
        _avatar = avatar;


  factory AuthUser({
    required String id,
    required String username,
    required String email,
    required String avatar,
    required String bearerToken
  }) {

    _instance ??= AuthUser._(
      id: id,
      username: username,
      email: email,
      avatar: avatar,
      bearerToken: bearerToken,
    );

    return _instance!;
  }

  static String? get bearerToken => _instance?._bearerToken;
  static String? get id => _instance?._id;
  static String? get username => _instance?._username;
  static String? get email => _instance?._email;
  static String? get avatar => _instance?._avatar;

  factory AuthUser.fromJson(Map<String, dynamic> data) {
    final userData = data['record'];

    return AuthUser(
      id: userData['id'],
      username: userData['username'],
      email: userData['email'],
      avatar: userData['avatar'],
      bearerToken: data['token']
    );
  }

  static bool isLoggedIn() => AuthUser.bearerToken != null && AuthUser.bearerToken!.isNotEmpty;

  static void clearCurrentInstance() {
    _instance = null;
  }
}
