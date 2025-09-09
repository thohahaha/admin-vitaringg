import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/news_model.dart';
import '../models/forum_model.dart';
import '../models/post_like_model.dart';

class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get newsCollection => _firestore.collection('news');
  CollectionReference get forumCollection => _firestore.collection('forum_posts');
  CollectionReference get postLikesCollection => _firestore.collection('post_likes');

  // === PENGGUNA MANAGEMENT ===
  
  /// Mendapatkan semua pengguna
  Stream<List<UserModel>> getUsers() {
    return usersCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList());
  }

  /// Mendapatkan pengguna berdasarkan ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data pengguna: $e');
    }
  }

  /// Mengubah peran pengguna
  Future<void> updateUserRole(String userId, String newRole) async {
    try {
      await usersCollection.doc(userId).update({
        'role': newRole,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Gagal mengubah peran pengguna: $e');
    }
  }

  /// Menghapus pengguna
  Future<void> deleteUser(String userId) async {
    try {
      await usersCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Gagal menghapus pengguna: $e');
    }
  }

  /// Menonaktifkan/mengaktifkan pengguna
  Future<void> toggleUserStatus(String userId, bool isActive) async {
    try {
      await usersCollection.doc(userId).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Gagal mengubah status pengguna: $e');
    }
  }

  // === BERITA MANAGEMENT ===

  /// Mendapatkan semua berita
  Stream<List<NewsModel>> getNews({int? limit}) {
    Query query = newsCollection.orderBy('createdAt', descending: true);
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => NewsModel.fromFirestore(doc)).toList());
  }

  /// Mendapatkan berita berdasarkan ID
  Future<NewsModel?> getNewsById(String newsId) async {
    try {
      final doc = await newsCollection.doc(newsId).get();
      if (doc.exists) {
        return NewsModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data berita: $e');
    }
  }

  /// Menambah berita baru
  Future<String> addNews(NewsModel news) async {
    try {
      final docRef = await newsCollection.add(news.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Gagal menambah berita: $e');
    }
  }

  /// Mengupdate berita
  Future<void> updateNews(String newsId, NewsModel updatedNews) async {
    try {
      await newsCollection.doc(newsId).update({
        ...updatedNews.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Gagal mengupdate berita: $e');
    }
  }

  /// Menghapus berita
  Future<void> deleteNews(String newsId) async {
    try {
      await newsCollection.doc(newsId).delete();
    } catch (e) {
      throw Exception('Gagal menghapus berita: $e');
    }
  }

  /// Mempublikasikan/membatalkan publikasi berita
  Future<void> toggleNewsPublication(String newsId, bool isPublished) async {
    try {
      await newsCollection.doc(newsId).update({
        'isPublished': isPublished,
        'publishedAt': isPublished ? FieldValue.serverTimestamp() : null,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Gagal mengubah status publikasi berita: $e');
    }
  }

  // === FORUM MANAGEMENT ===

  /// Mendapatkan semua post forum
  Stream<List<ForumPostModel>> getForumPosts({int? limit}) {
    Query query = forumCollection
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true);
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ForumPostModel.fromFirestore(doc)).toList());
  }

  /// Mendapatkan post forum berdasarkan ID
  Future<ForumPostModel?> getForumPostById(String postId) async {
    try {
      final doc = await forumCollection.doc(postId).get();
      if (doc.exists) {
        return ForumPostModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal mengambil data post forum: $e');
    }
  }

  /// Menghapus post forum (soft delete)
  Future<void> deleteForumPost(String postId) async {
    try {
      await forumCollection.doc(postId).update({
        'isDeleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Gagal menghapus post forum: $e');
    }
  }

  /// Memperbarui post forum
  Future<void> updateForumPost(String postId, Map<String, dynamic> updateData) async {
    try {
      // Tambahkan timestamp updated
      updateData['updatedAt'] = FieldValue.serverTimestamp();
      
      await forumCollection.doc(postId).update(updateData);
    } catch (e) {
      throw Exception('Gagal memperbarui post forum: $e');
    }
  }

  /// Mendapatkan semua komentar untuk sebuah post
  Stream<List<ForumComment>> getCommentsForPost(String postId) {
    return forumCollection
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ForumComment.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// Menghapus komentar dari post forum
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await forumCollection
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .update({'isDeleted': true});
    } catch (e) {
      throw Exception('Gagal menghapus komentar: $e');
    }
  }

  /// Mendapatkan semua likes untuk sebuah post
  Stream<List<PostLike>> getLikesForPost(String postId) {
    return postLikesCollection
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostLike.fromFirestore(doc))
            .toList());
  }

  // === STATISTIK DASHBOARD ===

  /// Mendapatkan jumlah total pengguna
  Future<int> getTotalUsers() async {
    try {
      print('🔍 Fetching total users from Firestore...');
      final snapshot = await usersCollection.get();
      final count = snapshot.docs.length;
      print('✅ Total users found: $count');
      return count;
    } catch (e) {
      print('❌ Error fetching users: $e');
      return 0;
    }
  }

  /// Mendapatkan jumlah total berita
  Future<int> getTotalNews() async {
    try {
      print('🔍 Fetching total news from Firestore...');
      final snapshot = await newsCollection.get();
      final count = snapshot.docs.length;
      print('✅ Total news found: $count');
      return count;
    } catch (e) {
      print('❌ Error fetching news: $e');
      return 0;
    }
  }

  /// Mendapatkan jumlah total post forum
  Future<int> getTotalForumPosts() async {
    try {
      print('🔍 Fetching total forum posts from Firestore...');
      final snapshot = await forumCollection
          .where('isDeleted', isEqualTo: false)
          .get();
      final count = snapshot.docs.length;
      print('✅ Total forum posts found: $count');
      return count;
    } catch (e) {
      print('❌ Error fetching forum posts: $e');
      return 0;
    }
  }

  /// Mendapatkan berita yang dipublikasi hari ini
  Future<int> getNewsPublishedToday() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await newsCollection
          .where('isPublished', isEqualTo: true)
          .where('publishedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('publishedAt', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  /// Menambah data dummy untuk testing
  Future<void> seedDummyData() async {
    try {
      // Tambah dummy users
      await _addDummyUsers();
      
      // Tambah dummy news
      await _addDummyNews();
      
      // Tambah dummy forum posts
      await _addDummyForumPosts();
    } catch (e) {
      throw Exception('Gagal menambah data dummy: $e');
    }
  }

  Future<void> _addDummyUsers() async {
    final users = [
      UserModel(
        id: '',
        name: 'Admin VitaRing',
        email: 'admin@vitaring.com',
        role: 'admin',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      UserModel(
        id: '',
        name: 'Dr. Sari Wijaya',
        email: 'dr.sari@vitaring.com',
        role: 'moderator',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      UserModel(
        id: '',
        name: 'Budi Santoso',
        email: 'budi@example.com',
        role: 'user',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      UserModel(
        id: '',
        name: 'Siti Nurhaliza',
        email: 'siti@example.com',
        role: 'user',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    for (final user in users) {
      await usersCollection.add(user.toFirestore());
    }
  }

  Future<void> _addDummyNews() async {
    final newsList = [
      NewsModel(
        id: '',
        title: 'Fitur Baru VitaRing: Monitoring Kesehatan Real-time',
        content: 'VitaRing telah merilis fitur monitoring kesehatan real-time yang memungkinkan pengguna untuk memantau detak jantung, tingkat stres, dan pola tidur secara kontinyu...',
        excerpt: 'Fitur monitoring kesehatan real-time kini tersedia di VitaRing untuk membantu pengguna memantau kondisi kesehatan mereka.',
        authorId: 'admin123',
        authorName: 'Admin VitaRing',
        publishedAt: DateTime.now().subtract(const Duration(days: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        isPublished: true,
        category: 'teknologi',
        tags: ['vitaring', 'kesehatan', 'teknologi'],
      ),
      NewsModel(
        id: '',
        title: 'Tips Menjaga Kesehatan Jantung dengan VitaRing',
        content: 'Kesehatan jantung adalah prioritas utama dalam kehidupan sehari-hari. Dengan VitaRing, Anda dapat memantau kondisi jantung Anda secara real-time...',
        excerpt: 'Pelajari cara menjaga kesehatan jantung dengan bantuan teknologi VitaRing.',
        authorId: 'dr123',
        authorName: 'Dr. Sari Wijaya',
        publishedAt: DateTime.now().subtract(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        isPublished: true,
        category: 'kesehatan',
        tags: ['kesehatan', 'jantung', 'tips'],
      ),
    ];

    for (final news in newsList) {
      await newsCollection.add(news.toFirestore());
    }
  }

  Future<void> _addDummyForumPosts() async {
    final forumPosts = [
      ForumPostModel(
        id: '',
        title: 'Bagaimana cara mengoptimalkan penggunaan VitaRing?',
        content: 'Saya baru saja membeli VitaRing dan ingin tahu tips untuk mengoptimalkan penggunaannya. Ada yang bisa berbagi pengalaman?',
        authorId: 'user123',
        authorName: 'Budi Santoso',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        category: 'diskusi',
        comments: [
          ForumComment(
            id: '0',
            content: 'Pastikan VitaRing selalu terpasang dengan baik dan bersihkan secara rutin.',
            authorId: 'mod123',
            authorName: 'Dr. Sari Wijaya',
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ],
        likeCount: 5,
        commentCount: 1,
        tags: ['tips', 'optimasi'],
      ),
      ForumPostModel(
        id: '',
        title: 'VitaRing vs competitor lain, mana yang lebih baik?',
        content: 'Saya sedang mempertimbangkan untuk membeli smart ring. Ada yang punya pengalaman membandingkan VitaRing dengan produk sejenis?',
        authorId: 'user456',
        authorName: 'Siti Nurhaliza',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        category: 'review',
        comments: [],
        likeCount: 3,
        commentCount: 0,
        tags: ['review', 'perbandingan'],
      ),
    ];

    for (final post in forumPosts) {
      await forumCollection.add(post.toFirestore());
    }
  }
}

extension ForumCommentExtension on ForumComment {
  ForumComment copyWith({
    String? content,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    bool? isDeleted,
  }) {
    return ForumComment(
      id: id,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
