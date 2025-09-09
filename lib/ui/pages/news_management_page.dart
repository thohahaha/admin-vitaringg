import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/neuromorphic_theme.dart';
import '../theme/neuromorphic_widgets.dart';
import '../../models/news_model.dart';
import '../../services/admin_service.dart';
import '../../services/image_service.dart';

class NewsManagementPage extends StatefulWidget {
  const NewsManagementPage({super.key});

  @override
  State<NewsManagementPage> createState() => _NewsManagementPageState();
}

class _NewsManagementPageState extends State<NewsManagementPage> {
  final AdminService _adminService = AdminService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuromorphicTheme.background,
      appBar: const NeuAppBar(
        title: 'Manajemen Berita & Artikel',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final padding = isMobile ? 8.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                // Header dengan search dan tombol tambah
                NeuCard(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
                    child: Column(
                      children: [
                        NeuTextField(
                          controller: _searchController,
                          hintText: 'Cari artikel...', 
                          prefixIcon: const Icon(
                            Icons.search,
                            color: NeuromorphicTheme.primary,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                        ),
                        if (isMobile) const SizedBox(height: 16),
                        if (!isMobile) const Spacer(),
                        NeuButton(
                          onPressed: () => _showAddNewsDialog(),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Tambah Artikel'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Stats cards
                StreamBuilder<List<NewsModel>>(
                  stream: _adminService.getNews(),
                  builder: (context, snapshot) {
                    final newsList = snapshot.data ?? [];
                    final publishedNews = 
                        newsList.where((n) => n.isPublished).length;
                    final totalViews = newsList.fold<int>(
                        0, (sum, news) => sum + news.viewCount);

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildStatCard(
                          'Total Artikel',
                          newsList.length.toString(),
                          Icons.article,
                          NeuromorphicTheme.primary,
                          isMobile,
                        ),
                        _buildStatCard(
                          'Dipublikasi',
                          publishedNews.toString(),
                          Icons.publish,
                          NeuromorphicTheme.success,
                          isMobile,
                        ),
                        _buildStatCard(
                          'Total Views',
                          totalViews.toString(),
                          Icons.visibility,
                          NeuromorphicTheme.warning,
                          isMobile,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Daftar berita
                NeuCard(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              'Daftar Artikel',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Spacer(),
                            StreamBuilder<List<NewsModel>>(
                              stream: _adminService.getNews(),
                              builder: (context, snapshot) {
                                final count = snapshot.data?.length ?? 0;
                                return Text(
                                  '$count artikel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: NeuromorphicTheme.textSecondary,
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      StreamBuilder<List<NewsModel>>(
                        stream: _adminService.getNews(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    NeuromorphicTheme.primary),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 64,
                                      color: NeuromorphicTheme.textSecondary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Gagal memuat data berita',
                                      style: 
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        'Error: ${snapshot.error}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: NeuromorphicTheme
                                                  .textSecondary,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final allNews = snapshot.data ?? [];
                          final filteredNews = allNews.where((news) {
                            if (_searchQuery.isEmpty) return true;
                            return news.title
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                news.content
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                news.authorName
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                news.category
                                    .toLowerCase()
                                    .contains(_searchQuery);
                          }).toList();

                          if (filteredNews.isEmpty) {
                            return Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.article_outlined,
                                      size: 64,
                                      color: NeuromorphicTheme.textSecondary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _searchQuery.isNotEmpty
                                          ? 'Tidak ada artikel yang ditemukan'
                                          : 'Belum ada artikel',
                                      style: 
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        _searchQuery.isNotEmpty
                                            ? 'Coba gunakan kata kunci lain'
                                            : 'Mulai tambah artikel pertama Anda',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: NeuromorphicTheme
                                                  .textSecondary,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (isMobile) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredNews.length,
                              itemBuilder: (context, index) {
                                final news = filteredNews[index];
                                return _buildNewsItem(news);
                              },
                            );
                          } else {
                            return DataTable(
                              columns: const [
                                DataColumn(label: Text('Judul')),
                                DataColumn(label: Text('Kategori')),
                                DataColumn(label: Text('Penulis')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Aksi')),
                              ],
                              rows: filteredNews
                                  .map((news) => DataRow(
                                        cells: [
                                          DataCell(Text(news.title)),
                                          DataCell(Text(news.category)),
                                          DataCell(Text(news.authorName)),
                                          DataCell(Text(news.isPublished
                                              ? 'Dipublikasi'
                                              : 'Draft')),
                                          DataCell(
                                            PopupMenuButton(
                                              icon: const Icon(Icons.more_vert),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 'toggle_publish',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        news.isPublished
                                                            ? Icons
                                                                .unpublished_outlined
                                                            : Icons.publish,
                                                        size: 16,
                                                        color: news.isPublished
                                                            ? Colors.orange
                                                            : Colors.green,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        news.isPublished
                                                            ? 'Batalkan Publikasi'
                                                            : 'Publikasikan',
                                                        style: TextStyle(
                                                          color: news.isPublished
                                                              ? Colors.orange
                                                              : Colors.green,
                                                        ),
                                                      ),
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
                                                      Icon(Icons.delete,
                                                          size: 16,
                                                          color: Colors.red),
                                                      SizedBox(width: 8),
                                                      Text('Hapus',
                                                          style: TextStyle( 
                                                              color: Colors.red)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onSelected: (value) =>
                                                  _handleNewsAction(
                                                      value.toString(), news),
                                            ),
                                          ),
                                        ],
                                      ))
                                  .toList(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isMobile) {
    return SizedBox(
      width: isMobile ? (MediaQuery.of(context).size.width / 2) - 24 : 200,
      child: NeuCard(
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: NeuromorphicTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem(NewsModel news) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: NeuCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    news.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: news.isPublished ? NeuromorphicTheme.success : NeuromorphicTheme.warning,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    news.isPublished ? 'DIPUBLIKASI' : 'DRAFT',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'toggle_publish',
                      child: Row(
                        children: [
                          Icon(
                            news.isPublished ? Icons.unpublished_outlined : Icons.publish,
                            size: 16,
                            color: news.isPublished ? Colors.orange : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            news.isPublished ? 'Batalkan Publikasi' : 'Publikasikan',
                            style: TextStyle(
                              color: news.isPublished ? Colors.orange : Colors.green,
                            ),
                          ),
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
              ],
            ),
            const SizedBox(height: 8),
            // Tampilkan gambar jika ada
            if (news.imageUrl != null && news.imageUrl!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: NeuromorphicTheme.textSecondary.withOpacity(0.2)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    news.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: NeuromorphicTheme.background,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              size: 40,
                              color: NeuromorphicTheme.textSecondary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Gagal memuat gambar',
                              style: TextStyle(
                                color: NeuromorphicTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: NeuromorphicTheme.background,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                            valueColor: const AlwaysStoppedAnimation<Color>(NeuromorphicTheme.primary),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: NeuromorphicTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                news.category.toUpperCase(),
                style: TextStyle(
                  color: NeuromorphicTheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              news.excerpt.isNotEmpty ? news.excerpt : news.content,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (news.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: news.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: NeuromorphicTheme.textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        color: NeuromorphicTheme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: NeuromorphicTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  news.authorName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 16, color: NeuromorphicTheme.textSecondary),
                const SizedBox(width: 4),
                Text(
                  _formatDate(news.createdAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.visibility, size: 16, color: NeuromorphicTheme.primary),
                    const SizedBox(width: 4),
                    Text(news.viewCount.toString()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else {
      return '${difference.inMinutes} menit lalu';
    }
  }

  void _handleNewsAction(String action, NewsModel news) {
    switch (action) {
      case 'toggle_publish':
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

  void _togglePublishStatus(NewsModel news) async {
    try {
      await _adminService.toggleNewsPublication(news.id, !news.isPublished);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${news.title} telah ${!news.isPublished ? 'dipublikasikan' : 'dibatalkan publikasinya'}',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah status publikasi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddNewsDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final excerptController = TextEditingController();
    final categoryController = TextEditingController(text: 'umum');
    final tagsController = TextEditingController();
    
    String? selectedImageUrl;
    Uint8List? selectedImageBytes;
    String? selectedImageName;
    bool isUploadingImage = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Tambah Artikel Baru'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NeuTextField(
                    controller: titleController,
                    hintText: 'Judul Artikel',
                    labelText: 'Judul',
                    prefixIcon: const Icon(Icons.title),
                  ),
                  const SizedBox(height: 16),
                  NeuTextField(
                    controller: categoryController,
                    hintText: 'Kategori (contoh: kesehatan, teknologi)',
                    labelText: 'Kategori',
                    prefixIcon: const Icon(Icons.category),
                  ),
                  const SizedBox(height: 16),
                  NeuTextField(
                    controller: excerptController,
                    hintText: 'Ringkasan singkat artikel',
                    labelText: 'Ringkasan',
                    prefixIcon: const Icon(Icons.subject),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  NeuTextField(
                    controller: contentController,
                    hintText: 'Konten artikel lengkap',
                    labelText: 'Konten',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  // Image upload section
                  NeuCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.image, color: NeuromorphicTheme.primary),
                              const SizedBox(width: 8),
                              const Text(
                                'Gambar Artikel',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: NeuromorphicTheme.primary,
                                ),
                              ),
                              const Spacer(),
                              if (isUploadingImage)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (selectedImageBytes != null)
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: NeuromorphicTheme.textSecondary.withOpacity(0.3)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  selectedImageBytes!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          else
                            Container(
                              width: double.infinity,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: NeuromorphicTheme.textSecondary.withOpacity(0.3),
                                  style: BorderStyle.solid,
                                ),
                                color: NeuromorphicTheme.background,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 40,
                                    color: NeuromorphicTheme.textSecondary,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Pilih gambar untuk artikel',
                                    style: TextStyle(
                                      color: NeuromorphicTheme.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Format: JPG, PNG, GIF (maks. 5MB)',
                                    style: TextStyle(
                                      color: NeuromorphicTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: NeuButton(
                                  onPressed: isUploadingImage ? null : () async {
                                    final imageData = await ImageService.pickImage();
                                    if (imageData != null) {
                                      // Validasi ukuran file
                                      if (!ImageService.isValidImageSize(imageData['size'])) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Ukuran gambar terlalu besar! Maksimal 5MB.'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                      
                                      // Validasi format file
                                      if (!ImageService.isValidImageFormat(imageData['extension'])) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Format gambar tidak didukung! Gunakan JPG, PNG, atau GIF.'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                      
                                      setState(() {
                                        selectedImageBytes = imageData['bytes'];
                                        selectedImageName = imageData['name'];
                                      });
                                    }
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.upload_file, size: 18),
                                      SizedBox(width: 8),
                                      Text('Pilih Gambar'),
                                    ],
                                  ),
                                ),
                              ),
                              if (selectedImageBytes != null) ...[
                                const SizedBox(width: 12),
                                NeuButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedImageBytes = null;
                                      selectedImageName = null;
                                      selectedImageUrl = null;
                                    });
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.clear, size: 18, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Hapus', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (selectedImageName != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'File: $selectedImageName',
                                style: TextStyle(
                                  color: NeuromorphicTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  NeuTextField(
                    controller: tagsController,
                    hintText: 'Tag dipisah koma (contoh: vitaring, kesehatan)',
                    labelText: 'Tags',
                    prefixIcon: const Icon(Icons.tag),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            NeuButton(
              onPressed: isUploadingImage ? null : () async {
                if (selectedImageBytes != null && selectedImageName != null) {
                  setState(() {
                    isUploadingImage = true;
                  });
                  
                  selectedImageUrl = await ImageService.uploadNewsImage(
                    selectedImageBytes!,
                    selectedImageName!,
                  );
                  
                  setState(() {
                    isUploadingImage = false;
                  });
                  
                  if (selectedImageUrl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal mengupload gambar. Silakan coba lagi.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                }
                
                _saveNewArticle(
                  titleController.text,
                  contentController.text,
                  excerptController.text,
                  categoryController.text,
                  tagsController.text,
                  selectedImageUrl,
                );
              },
              child: isUploadingImage
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Menyimpan...'),
                      ],
                    )
                  : const Text('Simpan Artikel'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNewArticle(String title, String content, String excerpt, String category, String tagsString, String? imageUrl) async {
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul dan konten harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context); // Tutup dialog

    try {
      final tags = tagsString.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
      
      final newsModel = NewsModel(
        id: '',
        title: title,
        content: content,
        excerpt: excerpt.isNotEmpty ? excerpt : content.substring(0, content.length > 100 ? 100 : content.length),
        authorId: 'admin123', // Untuk demo
        authorName: 'Admin VitaRing',
        publishedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPublished: false, // Default as draft
        imageUrl: imageUrl, // Tambahkan imageUrl
        category: category.isNotEmpty ? category : 'umum',
        tags: tags,
      );

      await _adminService.addNews(newsModel);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Artikel berhasil ditambahkan sebagai draft'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambah artikel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditNewsDialog(NewsModel news) {
    final titleController = TextEditingController(text: news.title);
    final contentController = TextEditingController(text: news.content);
    final excerptController = TextEditingController(text: news.excerpt);
    final categoryController = TextEditingController(text: news.category);
    final tagsController = TextEditingController(text: news.tags.join(', '));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Artikel'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NeuTextField(
                  controller: titleController,
                  hintText: 'Judul Artikel',
                  labelText: 'Judul',
                  prefixIcon: const Icon(Icons.title),
                ),
                const SizedBox(height: 16),
                NeuTextField(
                  controller: categoryController,
                  hintText: 'Kategori',
                  labelText: 'Kategori',
                  prefixIcon: const Icon(Icons.category),
                ),
                const SizedBox(height: 16),
                NeuTextField(
                  controller: excerptController,
                  hintText: 'Ringkasan',
                  labelText: 'Ringkasan',
                  prefixIcon: const Icon(Icons.subject),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                NeuTextField(
                  controller: contentController,
                  hintText: 'Konten artikel',
                  labelText: 'Konten',
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                NeuTextField(
                  controller: tagsController,
                  hintText: 'Tags',
                  labelText: 'Tags',
                  prefixIcon: const Icon(Icons.tag),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          NeuButton(
            onPressed: () => _updateArticle(
              news,
              titleController.text,
              contentController.text,
              excerptController.text,
              categoryController.text,
              tagsController.text,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _updateArticle(NewsModel news, String title, String content, String excerpt, String category, String tagsString) async {
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul dan konten harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context); // Tutup dialog

    try {
      final tags = tagsString.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
      
      final updatedNews = news.copyWith(
        title: title,
        content: content,
        excerpt: excerpt.isNotEmpty ? excerpt : content.substring(0, content.length > 100 ? 100 : content.length),
        category: category.isNotEmpty ? category : 'umum',
        tags: tags,
        updatedAt: DateTime.now(),
      );

      await _adminService.updateNews(news.id, updatedNews);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Artikel berhasil diupdate'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengupdate artikel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteNewsDialog(NewsModel news) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Artikel'),
        content: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              const TextSpan(text: 'Apakah Anda yakin ingin menghapus artikel '),
              TextSpan(
                text: '"${news.title}"',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '\nTindakan ini tidak dapat dibatalkan.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => _deleteArticle(news),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _deleteArticle(NewsModel news) async {
    Navigator.pop(context); // Tutup dialog
    
    try {
      await _adminService.deleteNews(news.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Artikel "${news.title}" berhasil dihapus'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus artikel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
