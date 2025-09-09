import 'package:cloud_firestore/cloud_firestore.dart';

class ForumComment {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final bool isDeleted;

  ForumComment({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.isDeleted = false,
  });

  factory ForumComment.fromMap(String id, Map<String, dynamic> data) {
    return ForumComment(
      id: id,
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isDeleted: data['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': Timestamp.fromDate(createdAt),
      'isDeleted': isDeleted,
    };
  }
}

class ForumPostModel {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final String category;
  final List<ForumComment> comments;
  final int likeCount;
  final int commentCount;
  final List<String> tags;

  ForumPostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
    required this.category,
    this.comments = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    this.tags = const [],
  });

  factory ForumPostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final commentsData = data['comments'] as List<dynamic>? ?? [];
    
    final comments = commentsData.asMap().entries.map((entry) {
      final index = entry.key;
      final commentData = entry.value as Map<String, dynamic>;
      return ForumComment.fromMap(index.toString(), commentData);
    }).toList();

    return ForumPostModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isDeleted: data['isDeleted'] ?? false,
      category: data['category'] ?? 'umum',
      comments: comments,
      likeCount: data['likeCount'] ?? 0,
      commentCount: data['commentCount'] ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isDeleted': isDeleted,
      'category': category,
      'comments': comments.map((comment) => comment.toMap()).toList(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'tags': tags,
    };
  }

  ForumPostModel copyWith({
    String? title,
    String? content,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    String? category,
    List<ForumComment>? comments,
    int? likeCount,
    int? commentCount,
    List<String>? tags,
  }) {
    return ForumPostModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      category: category ?? this.category,
      comments: comments ?? this.comments,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      tags: tags ?? this.tags,
    );
  }
}
