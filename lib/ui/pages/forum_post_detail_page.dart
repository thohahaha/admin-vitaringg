import 'package:flutter/material.dart';
import 'package:admin_vitaring/models/forum_model.dart';
import 'package:admin_vitaring/services/admin_service.dart';

class ForumPostDetailPage extends StatefulWidget {
  final ForumPostModel post;

  const ForumPostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  _ForumPostDetailPageState createState() => _ForumPostDetailPageState();
}

class _ForumPostDetailPageState extends State<ForumPostDetailPage> {
  final AdminService _adminService = AdminService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: StreamBuilder<List<ForumComment>>(
        stream: _adminService.getCommentsForPost(widget.post.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final comments = snapshot.data ?? [];

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return ListTile(
                title: Text(comment.authorName),
                subtitle: Text(comment.content),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _adminService.deleteComment(widget.post.id, comment.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
