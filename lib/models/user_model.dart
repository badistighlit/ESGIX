class User {
  final String apiKey;
  final String avatar;
  final String collectionId;
  final String collectionName;
  final DateTime created;
  final String email;
  final bool emailVisibility;
  final String id;
  final DateTime updated;
  final String username;
  final bool verified;
  final String token;

  static User? _instance;

  User._({
    required this.apiKey,
    required this.avatar,
    required this.collectionId,
    required this.collectionName,
    required this.created,
    required this.email,
    required this.emailVisibility,
    required this.id,
    required this.updated,
    required this.username,
    required this.verified,
    required this.token,
  });

  factory User({
    required String apiKey,
    required String avatar,
    required String collectionId,
    required String collectionName,
    required DateTime created,
    required String email,
    required bool emailVisibility,
    required String id,
    required DateTime updated,
    required String username,
    required bool verified,
    required String token,
  }) {
    _instance ??= User._(
      apiKey: apiKey,
      avatar: avatar,
      collectionId: collectionId,
      collectionName: collectionName,
      created: created,
      email: email,
      emailVisibility: emailVisibility,
      id: id,
      updated: updated,
      username: username,
      verified: verified,
      token: token,
    );
    return _instance!;
  }

  static User? get instance => _instance;

  static void clearUser() {
    _instance = null;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      apiKey: json['record']['api_key'],
      avatar: json['record']['avatar'],
      collectionId: json['record']['collectionId'],
      collectionName: json['record']['collectionName'],
      created: DateTime.parse(json['record']['created']),
      email: json['record']['email'],
      emailVisibility: json['record']['emailVisibility'],
      id: json['record']['id'],
      updated: DateTime.parse(json['record']['updated']),
      username: json['record']['username'],
      verified: json['record']['verified'],
      token: json['token'],
    );
  }
}

class Register {
  final String avatar;
  final String email;
  final String id;
  final String username;

  Register({
    required this.avatar,
    required this.email,
    required this.id,
    required this.username,
  });

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
        avatar: json['avatar'],
        email: json['email'],
        id: json['id'],
        username: json['username']
    );
  }
}
