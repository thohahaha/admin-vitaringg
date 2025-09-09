import 'package:flutter/material.dart';
import '../admin_scaffold.dart';
import '../admin_drawer.dart';

class ForumPage extends StatelessWidget {
  final List<dynamic> postList;
  final void Function(dynamic post)? onTapPost;

  const ForumPage({
    super.key,
    required this.postList,
    this.onTapPost,
  });

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Forum',
      drawer: AdminDrawer(selected: 'forum', onSelect: (v) {}),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: postList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, i) {
          final post = postList[i];
          return ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            tileColor: Colors.white,
            leading: const Icon(Icons.forum, color: Colors.orange),
            title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text('${post.likes.length}'),
                    const SizedBox(width: 12),
                    Icon(Icons.visibility, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text('${post.views}'),
                  ],
                ),
              ],
            ),
            onTap: () => onTapPost?.call(post),
          );
        },
      ),
    );
  }
}
