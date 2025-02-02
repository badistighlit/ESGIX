class User {
  final String? id;
  final String username;
  final String email;
  final String avatar;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      avatar: data['avatar'],
    );
  }
}