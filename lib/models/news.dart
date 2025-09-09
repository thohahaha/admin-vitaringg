// News model for Vita Ring admin panel
class News {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String author;
  final DateTime date;
  final List<String> likes;
  final int views;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.author,
    required this.date,
    required this.likes,
    required this.views,
  });

  factory News.fromMap(Map<String, dynamic> map, String id) {
    return News(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      author: map['author'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      likes: List<String>.from(map['likes'] ?? []),
      views: map['views'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'author': author,
      'date': date.toIso8601String(),
      'likes': likes,
      'views': views,
    };
  }
}
