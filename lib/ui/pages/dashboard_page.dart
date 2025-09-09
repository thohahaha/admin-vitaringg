// This is a simple, working dashboard page

import 'package:admin_vitaring/models/forum_model.dart';
import 'package:admin_vitaring/models/news_model.dart';
import 'package:flutter/material.dart';
import '../theme/neuromorphic_theme.dart';
import '../theme/neuromorphic_widgets.dart';
import '../../services/admin_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final AdminService _adminService = AdminService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuromorphicTheme.background,
      appBar: const NeuAppBar(
        title: 'Dashboard Admin VitaRing',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            FutureBuilder<List<int>>(
              future: Future.wait([
                _adminService.getTotalUsers(),
                _adminService.getTotalNews(),
                _adminService.getTotalForumPosts(),
              ]),
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
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: NeuromorphicTheme.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Gagal memuat data dashboard',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Error: ${snapshot.error}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: NeuromorphicTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }
                
                final stats = snapshot.data ?? [0, 0, 0];
                
                return GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStatCard(
                      'Total Pengguna',
                      stats[0].toString(),
                      Icons.people,
                      NeuromorphicTheme.primary,
                    ),
                    _buildStatCard(
                      'Total Berita',
                      stats[1].toString(),
                      Icons.article,
                      NeuromorphicTheme.success,
                    ),
                    _buildStatCard(
                      'Total Forum Posts',
                      stats[2].toString(),
                      Icons.forum,
                      NeuromorphicTheme.warning,
                    ),
                    _buildStatCard(
                      'Perangkat Aktif',
                      '2,103',
                      Icons.devices,
                      NeuromorphicTheme.error,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            _buildRecentPostsSection(),
            const SizedBox(height: 24),
            _buildRecentNewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return NeuCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: NeuromorphicTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPostsSection() {
    return NeuCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Postingan Forum Terbaru',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          StreamBuilder<List<ForumPostModel>>(
            stream: _adminService.getForumPosts(limit: 5),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Gagal memuat data'));
              }
              final posts = snapshot.data ?? [];
              if (posts.isEmpty) {
                return const Center(child: Text('Belum ada postingan'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return ListTile(
                    leading: const Icon(Icons.forum_outlined),
                    title: Text(post.title),
                    subtitle: Text('oleh ${post.authorName}'),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentNewsSection() {
    return NeuCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Berita Terbaru',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          StreamBuilder<List<NewsModel>>(
            stream: _adminService.getNews(limit: 5),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Gagal memuat data'));
              }
              final news = snapshot.data ?? [];
              if (news.isEmpty) {
                return const Center(child: Text('Belum ada berita'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: news.length,
                itemBuilder: (context, index) {
                  final article = news[index];
                  return ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: Text(article.title),
                    subtitle: Text(article.category),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
