import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  final String id;
  final String title;
  final String content;
  final String excerpt;
  final String authorId;
  final String authorName;
  final DateTime publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;
  final String? imageUrl;
  final List<String> tags;
  final String category;
  final int viewCount;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.authorId,
    required this.authorName,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.isPublished = false,
    this.imageUrl,
    this.tags = const [],
    required this.category,
    this.viewCount = 0,
  });

  factory NewsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NewsModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      excerpt: data['excerpt'] ?? '',
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      publishedAt: (data['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPublished: data['isPublished'] ?? false,
      imageUrl: data['imageUrl'],
      tags: List<String>.from(data['tags'] ?? []),
      category: data['category'] ?? 'umum',
      viewCount: data['viewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'excerpt': excerpt,
      'authorId': authorId,
      'authorName': authorName,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isPublished': isPublished,
      'imageUrl': imageUrl,
      'tags': tags,
      'category': category,
      'viewCount': viewCount,
    };
  }

  NewsModel copyWith({
    String? title,
    String? content,
    String? excerpt,
    String? authorId,
    String? authorName,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
    String? imageUrl,
    List<String>? tags,
    String? category,
    int? viewCount,
  }) {
    return NewsModel(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      excerpt: excerpt ?? this.excerpt,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      viewCount: viewCount ?? this.viewCount,
    );
  }
}
