class User {
  final String? id;
  final String? username;
  final String? email;
  final String? avatar;
  final String? description;

  User({
    this.id,
    this.username,
    this.email,
    this.avatar,
    this.description,
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      avatar: data['avatar'],
      description: data['description'],
    );
  }
}