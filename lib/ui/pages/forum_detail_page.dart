import 'package:flutter/material.dart';
import '../admin_scaffold.dart';
import '../admin_drawer.dart';

class ForumDetailPage extends StatelessWidget {
  final dynamic post;
  final List<dynamic> likedUsers;
  final List<dynamic> comments;

  const ForumDetailPage({super.key, required this.post, required this.likedUsers, required this.comments});

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: post.title,
      drawer: AdminDrawer(selected: 'forum', onSelect: (v) {}),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(post.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text('${post.likes.length}'),
                const SizedBox(width: 16),
                Icon(Icons.visibility, color: Colors.grey, size: 20),
                const SizedBox(width: 4),
                Text('${post.views}'),
              ],
            ),
            const SizedBox(height: 16),
            Text(post.content),
            const SizedBox(height: 32),
            Text('User yang Like:', style: Theme.of(context).textTheme.titleLarge),
            ...likedUsers.map((u) => ListTile(
              leading: const Icon(Icons.person),
              title: Text(u.name),
              subtitle: Text(u.email),
            )),
            const SizedBox(height: 32),
            Text('Komentar:', style: Theme.of(context).textTheme.titleLarge),
            ...comments.map((c) => ListTile(
              leading: const Icon(Icons.comment),
              title: Text(c.authorName),
              subtitle: Text(c.content),
            )),
          ],
        ),
      ),
    );
  }
}
