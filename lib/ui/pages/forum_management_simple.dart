import 'package:flutter/material.dart';
import '../theme/neuromorphic_theme.dart';
import '../../services/admin_service.dart';

class ForumManagementPage extends StatefulWidget {
  const ForumManagementPage({super.key});

  @override
  State<ForumManagementPage> createState() => _ForumManagementPageState();
}

class _ForumManagementPageState extends State<ForumManagementPage> {
  final AdminService _adminService = AdminService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuromorphicTheme.background,
      appBar: AppBar(
        title: const Text('Manajemen Forum'),
        backgroundColor: NeuromorphicTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddForumDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Card(
              color: NeuromorphicTheme.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Daftar Diskusi Forum',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _addDemoData,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Tambah Data Demo'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Forum list
            Expanded(
              child: StreamBuilder(
                stream: _adminService.getForumPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(NeuromorphicTheme.primary),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          const Text('Gagal memuat data forum'),
                          const SizedBox(height: 8),
                          Text('Error: ${snapshot.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _addDemoData,
                            child: const Text('Tambah Data Demo'),
                          ),
                        ],
                      ),
                    );
                  }

                  final forumPosts = snapshot.data ?? [];
                  
                  if (forumPosts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.forum_outlined,
                            size: 64,
                            color: NeuromorphicTheme.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada diskusi forum',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tambah data demo untuk melihat daftar diskusi',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _addDemoData,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            child: const Text('Tambah Data Demo'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: forumPosts.length,
                    itemBuilder: (context, index) {
                      final post = forumPosts[index];
                      return Card(
                        color: NeuromorphicTheme.cardBackground,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.forum,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            post.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(post.category),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      post.category.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Oleh: ${post.authorName}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      const Icon(Icons.comment, size: 12),
                                      const SizedBox(width: 2),
                                      Text(
                                        '0',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'lock',
                                child: Text('Kunci Diskusi'),
                              ),
                              const PopupMenuItem(
                                value: 'pin',
                                child: Text('Pin/Unpin'),
                              ),
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Hapus'),
                              ),
                            ],
                            onSelected: (value) => _handleForumAction(value.toString(), post),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'teknologi':
        return Colors.blue;
      case 'kesehatan':
        return Colors.green;
      case 'olahraga':
        return Colors.orange;
      case 'gaya hidup':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _handleForumAction(String action, dynamic post) {
    switch (action) {
      case 'lock':
        _toggleLockStatus(post);
        break;
      case 'pin':
        _togglePinStatus(post);
        break;
      case 'edit':
        _showEditForumDialog(post);
        break;
      case 'delete':
        _showDeleteForumDialog(post);
        break;
    }
  }

  void _toggleLockStatus(dynamic post) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kunci Diskusi'),
        content: const Text('Fitur kunci diskusi akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _togglePinStatus(dynamic post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pin Diskusi'),
        content: const Text('Fitur pin diskusi akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEditForumDialog(dynamic post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Diskusi'),
        content: const Text('Fitur edit diskusi akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteForumDialog(dynamic post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Diskusi'),
        content: Text(
          'Apakah Anda yakin ingin menghapus diskusi "${post.title}"? '
          'Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => _deleteForumPost(post),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _deleteForumPost(dynamic post) async {
    Navigator.pop(context);

    try {
      await _adminService.deleteForumPost(post.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Diskusi "${post.title}" berhasil dihapus'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus diskusi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddForumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Diskusi'),
        content: const Text('Fitur tambah diskusi akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addDemoData() async {
    try {
      await _adminService.seedDummyData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data demo berhasil ditambahkan!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambah data demo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
