
import 'package:cloud_firestore/cloud_firestore.dart';

class PostLike {
  final String id;
  final String postId;
  final String userId;
  final DateTime createdAt;

  PostLike({
    required this.id,
    required this.postId,
    required this.userId,
    required this.createdAt,
  });

  factory PostLike.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostLike(
      id: doc.id,
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
