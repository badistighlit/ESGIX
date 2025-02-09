class Post {
 final String id;
 final String? idParent;
 final Author author;
 final DateTime createdAt;
 DateTime? updatedAt;
 final String? imageUrl;
 String content;
 int likesCount;
 int commentsCount;
 bool likedByUser;

 Post({
  required this.id,
  this.idParent,
  required this.author,
  required this.content,
  required this.createdAt,
  this.updatedAt,
  this.imageUrl,
  required this.commentsCount,
  required this.likesCount,
  required this.likedByUser,
 });

 factory Post.fromJson(Map<String, dynamic> json) {
  return Post(
   id: json['id'] as String,
   idParent: json['parent'] as String?,
   author: Author.fromJson(json['author']),
   content: json['content'] as String,
   createdAt: DateTime.parse(json['createdAt'] as String),
   updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
   imageUrl: json['imageUrl'] as String?,
   commentsCount: json['commentsCount'] ?? 0,
   likesCount: json['likesCount'] as int,
   likedByUser: json['likedByUser'] ?? false,
  );
 }

 Map<String, dynamic> toJson() {
  return {
   'id': id,
   'parent': idParent,
   'author': author.toJson(),
   'content': content,
   'createdAt': createdAt.toIso8601String(),
   'updatedAt': updatedAt?.toIso8601String(),
   'imageUrl': imageUrl,
   'commentsCount': commentsCount,
   'likesCount': likesCount,
   'likedByUser': likedByUser,
  };
 }
}

class Author {
 final String id;
 final String username;
 final String? avatar;

 Author({
  required this.id,
  required this.username,
  this.avatar,
 });

 factory Author.fromJson(Map<String, dynamic> json) {
  return Author(
   id: json['id'] as String,
   username: json['username'] as String,
   avatar: json['avatar'] as String?,
  );
 }

 Map<String, dynamic> toJson() {
  return {
   'id': id,
   'username': username,
   'avatar': avatar,
  };
 }
}
