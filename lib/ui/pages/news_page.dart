import 'package:flutter/material.dart';
import '../admin_scaffold.dart';
import '../admin_drawer.dart';

class NewsPage extends StatelessWidget {
  final List<dynamic> newsList;
  final void Function()? onAddNews;
  final void Function(dynamic news)? onTapNews;

  const NewsPage({
    super.key,
    required this.newsList,
    this.onAddNews,
    this.onTapNews,
  });

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Berita',
      drawer: AdminDrawer(selected: 'news', onSelect: (v) {}),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddNews,
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: newsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final news = newsList[i];
          return ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            tileColor: Colors.white,
            leading: news.imageUrl != null ? Image.network(news.imageUrl, width: 56, height: 56, fit: BoxFit.cover) : null,
            title: Text(news.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(news.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text('${news.likes.length}'),
                    const SizedBox(width: 12),
                    Icon(Icons.visibility, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text('${news.views}'),
                  ],
                ),
              ],
            ),
            onTap: () => onTapNews?.call(news),
          );
        },
      ),
    );
  }
}
