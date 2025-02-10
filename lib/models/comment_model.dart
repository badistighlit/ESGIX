class CommentModel {
  final String id;
  final String idParent;
  final Author? author;
  final DateTime? createdAt;
  DateTime? updatedAt;
  final String ? imageUrl;
  String content;
  int likesCount;
  int commentsCount;


  CommentModel({
    required this.id,
    required this.idParent,
    this.author,
    required this.content,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    required this.commentsCount,
    required this.likesCount,
  });

  static CommentModel copyWith({required String parentId, required String content, String? imageUrl}) {
    return CommentModel(
      id: '',
      idParent: parentId,
      author: null,
      content: content,
      createdAt: null,
      updatedAt: null,
      imageUrl: imageUrl,
      commentsCount: 0,
      likesCount: 0,
    );
  }


  // Mapping de Json en objet
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      idParent: json['parent'] as String,
      author: Author.fromJson(json['author']),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      commentsCount: json['commentsCount'] as int,
      likesCount: json['likesCount'] as int,
    );
  }

  // Mapping d'objet en JSON

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent': idParent,
      'author': author?.toJson(),
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'imageUrl': imageUrl,
      'commentsCount': commentsCount,
      'likesCount': likesCount,
    };
  }
}


class Author {
  final String id;
  final String username;
  final String? avatar;
//constructeur
  Author({
    required this.id,
    required this.username,
    this.avatar,
  });
// MApping de Json en modele
  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
    );
  }

  // MApping de modele en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': avatar,
    };
  }
}
