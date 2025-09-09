import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/theme/neuromorphic_theme.dart';
import 'ui/theme/neuromorphic_widgets.dart';
import 'ui/pages/users_management_page.dart';
import 'ui/pages/news_management_page.dart';
import 'ui/pages/forum_management_page.dart';
import 'ui/pages/health_monitoring_page.dart';
import 'services/admin_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const VitaRingAdminApp());
}

class VitaRingAdminApp extends StatelessWidget {
  const VitaRingAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vita Ring Admin Panel',
      debugShowCheckedModeBanner: false,
      theme:
       NeuromorphicTheme.themeData,
      home: const AdminLoginPage(),
      routes: {
        '/dashboard': (context) => const AdminDashboard(),
      },
    );
  }
}

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _emailController = TextEditingController(text: 'admin@vitaring.com');
  final _passwordController = TextEditingController(text: 'password');
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      // Demo login for now - simple credential check
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      if (_emailController.text == 'admin@vitaring.com' && 
          _passwordController.text == 'password') {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        _showErrorDialog('Email atau password salah');
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Masuk'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuromorphicTheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: NeuCard(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo and title
                Icon(
                  Icons.admin_panel_settings,
                  size: 64,
                  color: NeuromorphicTheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Vita Ring Admin',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: NeuromorphicTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masuk Admin Panel',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: NeuromorphicTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Email field
                NeuTextField(
                  controller: _emailController,
                  hintText: 'Masukkan email Anda',
                  labelText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: NeuromorphicTheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Password field
                NeuTextField(
                  controller: _passwordController,
                  hintText: 'Masukkan password Anda',
                  labelText: 'Password',
                  obscureText: true,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: NeuromorphicTheme.primary,
                  ),
                ),
                const SizedBox(height: 24),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: NeuButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text('Masuk'),
                  ),
                ),
                const SizedBox(height: 16),

                // Demo credentials info
                NeuContainer(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        'Kredensial Demo:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: NeuromorphicTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Email: admin@vitaring.com',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Password: password',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Add demo data button
                SizedBox(
                  width: double.infinity,
                  child: NeuButton(
                    onPressed: () async {
                      try {
                        final adminService = AdminService();
                        await adminService.seedDummyData();
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
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    backgroundColor: Colors.green,
                    child: const Text('Tambah Data Demo'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminService adminService = AdminService();
    
    return Scaffold(
      backgroundColor: NeuromorphicTheme.background,
      appBar: const NeuAppBar(
        title: 'Panel Admin VitaRing',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<int>>(
          future: Future.wait([
            adminService.getTotalUsers(),
            adminService.getTotalNews(),
            adminService.getTotalForumPosts(),
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
                      'Gagal memuat data',
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
                        // Force rebuild
                        (context as Element).markNeedsBuild();
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
              children: [
                _buildDashboardCard(
                  context,
                  'Manajemen Pengguna',
                  Icons.people,
                  '${stats[0]} Pengguna',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UsersManagementPage()),
                  ),
                ),
                _buildDashboardCard(
                  context,
                  'Berita & Artikel',
                  Icons.article,
                  '${stats[1]} Artikel',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewsManagementPage()),
                  ),
                ),
                _buildDashboardCard(
                  context,
                  'Post Forum',
                  Icons.forum,
                  '${stats[2]} Post',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForumManagementPage()),
                  ),
                ),
                _buildDashboardCard(
                  context,
                  'Monitoring Kesehatan',
                  Icons.monitor_heart,
                  'Data Real-time',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HealthMonitoringPage()),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: NeuromorphicTheme.background,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: NeuromorphicTheme.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  'Vita Ring Admin',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.dashboard, 'Dashboard', () {}),
                _buildDrawerItem(Icons.people, 'Manajemen Pengguna', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UsersManagementPage(),
                    ),
                  );
                }),
                _buildDrawerItem(Icons.article, 'Berita & Artikel', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewsManagementPage(),
                    ),
                  );
                }),
                _buildDrawerItem(Icons.forum, 'Manajemen Forum', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForumManagementPage(),
                    ),
                  );
                }),
                _buildDrawerItem(Icons.monitor_heart, 'Monitoring Kesehatan', () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HealthMonitoringPage(),
                    ),
                  );
                }),
                _buildDrawerItem(Icons.settings, 'Settings', () => _showComingSoon(context)),
              ],
            ),
          ),
          const Divider(),
          _buildDrawerItem(
            Icons.logout,
            'Logout',
            () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: NeuromorphicTheme.primary),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return NeuCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: NeuromorphicTheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text('This feature is under development and will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
