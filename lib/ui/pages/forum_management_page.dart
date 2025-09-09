import 'package:admin_vitaring/models/post_like_model.dart';
import 'package:admin_vitaring/models/user_model.dart';
import 'package:admin_vitaring/ui/pages/forum_post_detail_page.dart';
import 'package:flutter/material.dart';
import '../theme/neuromorphic_theme.dart';
import '../theme/neuromorphic_widgets.dart';
import '../../models/forum_model.dart';
import '../../services/admin_service.dart';

class ForumManagementPage extends StatefulWidget {
  const ForumManagementPage({super.key});

  @override
  State<ForumManagementPage> createState() => _ForumManagementPageState();
}

class _ForumManagementPageState extends State<ForumManagementPage> {
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
        title: 'Manajemen Forum',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final padding = isMobile ? 8.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                // Header dengan search dan tools
                NeuCard(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
                    child: Column(
                      children: [
                        NeuTextField(
                          controller: _searchController,
                          hintText: 'Cari post forum...',
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
                          onPressed: () => _showModerateDialog(),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.admin_panel_settings, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Tools Moderasi'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Stats cards
                StreamBuilder<List<ForumPostModel>>(
                  stream: _adminService.getForumPosts(),
                  builder: (context, snapshot) {
                    final posts = snapshot.data ?? [];
                    final totalComments = posts.fold<int>(
                        0, (sum, post) => sum + post.commentCount);
                    final totalLikes = posts.fold<int>(
                        0, (sum, post) => sum + post.likeCount);

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildStatCard(
                          'Total Post',
                          posts.length.toString(),
                          Icons.forum,
                          NeuromorphicTheme.primary,
                          isMobile,
                        ),
                        _buildStatCard(
                          'Total Komentar',
                          totalComments.toString(),
                          Icons.comment,
                          NeuromorphicTheme.success,
                          isMobile,
                        ),
                        _buildStatCard(
                          'Total Likes',
                          totalLikes.toString(),
                          Icons.favorite,
                          NeuromorphicTheme.error,
                          isMobile,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Daftar post forum
                NeuCard(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              'Post Forum',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Spacer(),
                            StreamBuilder<List<ForumPostModel>>(
                              stream: _adminService.getForumPosts(),
                              builder: (context, snapshot) {
                                final count = snapshot.data?.length ?? 0;
                                return Text(
                                  '$count post',
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
                      StreamBuilder<List<ForumPostModel>>(
                        stream: _adminService.getForumPosts(),
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
                                      'Gagal memuat data forum',
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

                          final allPosts = snapshot.data ?? [];
                          final filteredPosts = allPosts.where((post) {
                            if (_searchQuery.isEmpty) return true;
                            return post.title
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                post.content
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                post.authorName
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                post.category
                                    .toLowerCase()
                                    .contains(_searchQuery);
                          }).toList();

                          if (filteredPosts.isEmpty) {
                            return Center(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.forum_outlined,
                                      size: 64,
                                      color: NeuromorphicTheme.textSecondary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _searchQuery.isNotEmpty
                                          ? 'Tidak ada post yang ditemukan'
                                          : 'Belum ada post forum',
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
                                            : 'Post forum akan muncul di sini setelah ada aktivitas',
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
                              itemCount: filteredPosts.length,
                              itemBuilder: (context, index) {
                                final post = filteredPosts[index];
                                return _buildPostItem(post);
                              },
                            );
                          } else {
                            return DataTable(
                              columns: const [
                                DataColumn(label: Text('Judul')),
                                DataColumn(label: Text('Penulis')),
                                DataColumn(label: Text('Kategori')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Aksi')),
                              ],
                              rows: filteredPosts
                                  .map((post) => DataRow(
                                        cells: [
                                          DataCell(Text(post.title)),
                                          DataCell(Text(post.authorName)),
                                          DataCell(Text(post.category)),
                                          DataCell(Text('Pending')),
                                          DataCell(
                                            PopupMenuButton(
                                              icon: const Icon(Icons.more_vert),
                                              itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                  value: 'approve',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.check,
                                                          size: 16,
                                                          color: Colors.green),
                                                      SizedBox(width: 8),
                                                      Text('Setujui'),
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
                                                const PopupMenuItem(
                                                  value: 'hide',
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.visibility_off,
                                                          size: 16,
                                                          color: Colors.orange),
                                                      SizedBox(width: 8),
                                                      Text('Sembunyikan'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              onSelected: (value) =>
                                                  _handlePostAction(
                                                      value.toString(), post),
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

  Widget _buildPostItem(ForumPostModel post) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForumPostDetailPage(post: post),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: NeuCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: NeuromorphicTheme.primary,
                    child: Text(
                      post.authorName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          post.authorName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: NeuromorphicTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'approve',
                        child: Row(
                          children: [
                            Icon(Icons.check, size: 16, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Setujui'),
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
                      const PopupMenuItem(
                        value: 'hide',
                        child: Row(
                          children: [
                            Icon(Icons.visibility_off, size: 16, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Sembunyikan'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) => _handlePostAction(value.toString(), post),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.content,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: NeuromorphicTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(post.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => _showLikesDialog(post),
                    child: Row(
                      children: [
                        Icon(Icons.favorite, size: 16, color: NeuromorphicTheme.error),
                        const SizedBox(width: 4),
                        Text(post.likeCount.toString()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.comment, size: 16, color: NeuromorphicTheme.primary),
                  const SizedBox(width: 4),
                  Text(post.commentCount.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  void _handlePostAction(String action, ForumPostModel post) async {
    switch (action) {
      case 'approve':
        try {
          await _adminService.updateForumPost(post.id, {'isApproved': true});
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Post "${post.title}" disetujui!')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal menyetujui post: $e')),
            );
          }
        }
        break;
      case 'delete':
        _showDeletePostDialog(post);
        break;
      case 'hide':
        try {
          await _adminService.updateForumPost(post.id, {'isVisible': false});
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Post "${post.title}" disembunyikan!')),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal menyembunyikan post: $e')),
            );
          }
        }
        break;
    }
  }

  void _showLikesDialog(ForumPostModel post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Disukai oleh'),
        content: StreamBuilder<List<PostLike>>(
          stream: _adminService.getLikesForPost(post.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Text('Gagal memuat data');
            }
            final likes = snapshot.data ?? [];
            if (likes.isEmpty) {
              return const Text('Belum ada yang menyukai post ini');
            }
            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: likes.length,
                itemBuilder: (context, index) {
                  final like = likes[index];
                  return FutureBuilder<UserModel?>(
                    future: _adminService.getUserById(like.userId),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(title: Text('Memuat...'));
                      }
                      if (userSnapshot.hasError || !userSnapshot.hasData) {
                        return const ListTile(title: Text('Pengguna tidak ditemukan'));
                      }
                      final user = userSnapshot.data!;
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(user.name[0].toUpperCase()),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                      );
                    },
                  );
                },
              ),
            );
          },
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

  void _showDeletePostDialog(ForumPostModel post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Post'),
        content: Text('Apakah Anda yakin ingin menghapus "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _adminService.deleteForumPost(post.id);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post berhasil dihapus!')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus post: $e')),
                  );
                }
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showModerateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tools Moderasi'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Setujui Semua Pending'),
                subtitle: Text('Setujui semua post yang menunggu'),
              ),
              ListTile(
                leading: Icon(Icons.block, color: Colors.red),
                title: Text('Blokir Pengguna'),
                subtitle: Text('Blokir pengguna tertentu'),
              ),
              ListTile(
                leading: Icon(Icons.report, color: Colors.orange),
                title: Text('Tinjau Laporan'),
                subtitle: Text('Tinjau post yang dilaporkan'),
              ),
            ],
          ),
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
}
