import 'package:flutter/material.dart';
import '../theme/neuromorphic_theme.dart';
import '../../services/admin_service.dart';
import 'news_detail_page.dart';

class NewsManagementPage extends StatefulWidget {
  const NewsManagementPage({super.key});

  @override
  State<NewsManagementPage> createState() => _NewsManagementPageState();
}

class _NewsManagementPageState extends State<NewsManagementPage> {
  final AdminService _adminService = AdminService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuromorphicTheme.background,
      appBar: AppBar(
        title: const Text('Manajemen Berita & Artikel'),
        backgroundColor: NeuromorphicTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddNewsDialog,
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
                        'Daftar Berita & Artikel',
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
            
            // News list
            Expanded(
              child: StreamBuilder(
                stream: _adminService.getNews(),
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
                          const Text('Gagal memuat data berita'),
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

                  final newsList = snapshot.data ?? [];
                  
                  if (newsList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.article_outlined,
                            size: 64,
                            color: NeuromorphicTheme.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada berita',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tambah data demo untuk melihat daftar berita',
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
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final news = newsList[index];
                      return Card(
                        color: NeuromorphicTheme.cardBackground,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: news.isPublished ? Colors.green : Colors.orange,
                            child: Icon(
                              news.isPublished ? Icons.published_with_changes : Icons.edit_note,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            news.title,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                news.excerpt,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(news.category),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      news.category.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Oleh: ${news.authorName}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'view',
                                child: Row(
                                  children: [
                                    const Icon(Icons.visibility, size: 16),
                                    const SizedBox(width: 8),
                                    const Text('Lihat Detail'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'publish',
                                child: Row(
                                  children: [
                                    Icon(
                                      news.isPublished ? Icons.visibility_off : Icons.visibility,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(news.isPublished ? 'Batal Publish' : 'Publish'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 16),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 16, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Hapus', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) => _handleNewsAction(value.toString(), news),
                          ),
                          onTap: () => _openNewsDetail(news),
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
      default:
        return Colors.grey;
    }
  }

  void _handleNewsAction(String action, dynamic news) {
    switch (action) {
      case 'view':
        _openNewsDetail(news);
        break;
      case 'publish':
        _togglePublishStatus(news);
        break;
      case 'edit':
        _showEditNewsDialog(news);
        break;
      case 'delete':
        _showDeleteNewsDialog(news);
        break;
    }
  }

  void _openNewsDetail(dynamic news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(news: news),
      ),
    );
  }

  void _togglePublishStatus(dynamic news) async {
    try {
      await _adminService.toggleNewsPublication(news.id, !news.isPublished);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              news.isPublished ? 'Berita dibatalkan publish' : 'Berita dipublish',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditNewsDialog(dynamic news) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Berita'),
        content: const Text('Fitur edit berita akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteNewsDialog(dynamic news) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Berita'),
        content: Text(
          'Apakah Anda yakin ingin menghapus berita "${news.title}"? '
          'Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => _deleteNews(news),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _deleteNews(dynamic news) async {
    Navigator.pop(context);

    try {
      await _adminService.deleteNews(news.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berita "${news.title}" berhasil dihapus'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus berita: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddNewsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Berita'),
        content: const Text('Fitur tambah berita akan segera tersedia.'),
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
