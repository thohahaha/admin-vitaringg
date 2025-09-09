import 'package:flutter/material.dart';
import '../theme/neuromorphic_theme.dart';
import '../../services/admin_service.dart';

class NewsDetailPage extends StatefulWidget {
  final dynamic news;
  
  const NewsDetailPage({super.key, required this.news});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final AdminService _adminService = AdminService();
  bool _isLiked = false;
  int _likeCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeLikeData();
  }

  void _initializeLikeData() {
    // Simulasi data like berdasarkan hash dari ID berita
    final newsId = widget.news.id ?? '';
    _likeCount = 15 + (newsId.hashCode % 100);
    _isLiked = (newsId.hashCode % 3) == 0; // Sekitar 33% kemungkinan sudah di-like
  }

  @override
  Widget build(BuildContext context) {
    final news = widget.news;
    
    return Scaffold(
      backgroundColor: NeuromorphicTheme.background,
      appBar: AppBar(
        title: const Text('Detail Berita'),
        backgroundColor: NeuromorphicTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareNews,
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit Berita'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Hapus Berita'),
              ),
              PopupMenuItem(
                value: 'publish',
                child: Text(news.isPublished ? 'Unpublish' : 'Publish'),
              ),
            ],
            onSelected: (value) => _handleAction(value.toString()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              color: NeuromorphicTheme.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: news.isPublished ? Colors.green : Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            news.isPublished ? 'PUBLISHED' : 'DRAFT',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(news.category),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            news.category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Title
                    Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Author and Date
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: NeuromorphicTheme.primary,
                          radius: 16,
                          child: Text(
                            news.authorName.isNotEmpty ? news.authorName[0].toUpperCase() : 'A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              news.authorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              _formatDate(news.createdAt),
                              style: TextStyle(
                                color: NeuromorphicTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Like Button and Count
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _toggleLike,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _isLiked ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _isLiked ? Colors.red : Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isLiked ? Icons.favorite : Icons.favorite_border,
                                      color: _isLiked ? Colors.red : Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _likeCount.toString(),
                                      style: TextStyle(
                                        color: _isLiked ? Colors.red : Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Excerpt Card
            if (news.excerpt.isNotEmpty) ...[
              Card(
                color: NeuromorphicTheme.cardBackground,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.format_quote,
                            color: NeuromorphicTheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Ringkasan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: NeuromorphicTheme.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: NeuromorphicTheme.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          news.excerpt,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                            color: NeuromorphicTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Content Card
            Card(
              color: NeuromorphicTheme.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.article,
                          color: NeuromorphicTheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Isi Berita',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      news.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Statistics Card
            Card(
              color: NeuromorphicTheme.cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.analytics,
                          color: NeuromorphicTheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Statistik',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.favorite,
                            label: 'Likes',
                            value: _likeCount.toString(),
                            color: Colors.red,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.visibility,
                            label: 'Views',
                            value: ((_likeCount * 8) + 127).toString(),
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.share,
                            label: 'Shares',
                            value: ((_likeCount ~/ 5) + 3).toString(),
                            color: Colors.green,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.comment,
                            label: 'Comments',
                            value: ((_likeCount ~/ 3) + 7).toString(),
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _handleAction('edit'),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Berita'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NeuromorphicTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _handleAction('publish'),
                    icon: Icon(news.isPublished ? Icons.visibility_off : Icons.visibility),
                    label: Text(news.isPublished ? 'Unpublish' : 'Publish'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: news.isPublished ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
      case 'ekonomi':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Tanggal tidak tersedia';
    
    try {
      if (date is String) {
        return date;
      }
      // Jika menggunakan Timestamp dari Firestore
      final DateTime dateTime = date.toDate();
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return 'Hari ini';
    }
  }

  void _toggleLike() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    // Simulasi API call
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLiked ? 'Berita disukai!' : 'Like dihapus',
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: _isLiked ? Colors.green : Colors.grey,
        ),
      );
    }

    // TODO: Implement actual like functionality with AdminService
    // try {
    //   await _adminService.toggleNewsLike(widget.news.id, _isLiked);
    // } catch (e) {
    //   // Handle error
    // }
  }

  void _shareNews() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bagikan Berita'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.link, color: Colors.blue),
              title: const Text('Salin Link'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Link berhasil disalin!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.green),
              title: const Text('Bagikan ke Media Sosial'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur berbagi akan segera tersedia!')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _handleAction(String action) async {
    switch (action) {
      case 'edit':
        _showEditDialog();
        break;
      case 'delete':
        _showDeleteDialog();
        break;
      case 'publish':
        _togglePublishStatus();
        break;
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Berita'),
        content: const Text('Fitur edit berita akan segera tersedia dengan form lengkap.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Berita'),
        content: Text(
          'Apakah Anda yakin ingin menghapus berita "${widget.news.title}"?\n\n'
          'Tindakan ini tidak dapat dibatalkan dan akan menghapus semua data termasuk:\n'
          '• $_likeCount likes\n'
          '• ${(_likeCount * 8) + 127} views\n'
          '• ${(_likeCount ~/ 3) + 7} comments',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => _deleteNews(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteNews() async {
    Navigator.pop(context); // Close dialog
    
    setState(() {
      _isLoading = true;
    });

    try {
      await _adminService.deleteNews(widget.news.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berita "${widget.news.title}" berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to news list
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _togglePublishStatus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _adminService.toggleNewsPublication(widget.news.id, !widget.news.isPublished);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.news.isPublished ? 'Berita berhasil di-unpublish' : 'Berita berhasil dipublish',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Update the UI
        setState(() {
          widget.news.isPublished = !widget.news.isPublished;
        });
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
