import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'ui/theme/neuromorphic_theme.dart';
import 'ui/theme/neuromorphic_widgets.dart';
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
      theme: NeuromorphicTheme.themeData,
      home: const AdminLoginPage(),
      routes: {
        '/dashboard': (context) => const AdminDashboard(),
        '/users': (context) => const SimpleUsersPage(),
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
      await Future.delayed(const Duration(seconds: 1));
      
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

  Future<void> _addDemoData() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuromorphicTheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and title
                const Icon(
                  Icons.admin_panel_settings,
                  size: 64,
                  color: NeuromorphicTheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Vita Ring Admin',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Masuk'),
                  ),
                ),
                const SizedBox(height: 16),

                // Demo data button
                SizedBox(
                  width: double.infinity,
                  child: NeuButton(
                    onPressed: _addDemoData,
                    backgroundColor: Colors.green,
                    child: const Text('Tambah Data Demo'),
                  ),
                ),
                const SizedBox(height: 16),

                // Demo credentials info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: NeuromorphicTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
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
    return Scaffold(
      backgroundColor: NeuromorphicTheme.background,
      appBar: AppBar(
        title: const Text('Panel Admin VitaRing'),
        backgroundColor: NeuromorphicTheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        backgroundColor: NeuromorphicTheme.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: NeuromorphicTheme.primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Vita Ring Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: NeuromorphicTheme.primary),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.people, color: NeuromorphicTheme.primary),
              title: const Text('Manajemen Pengguna'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/users');
              },
            ),
            ListTile(
              leading: const Icon(Icons.article, color: NeuromorphicTheme.primary),
              title: const Text('Berita & Artikel'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.forum, color: NeuromorphicTheme.primary),
              title: const Text('Manajemen Forum'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.monitor_heart, color: NeuromorphicTheme.primary),
              title: const Text('Monitoring Kesehatan'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<int>>(
          future: _getStats(),
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
                      color: NeuromorphicTheme.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gagal memuat data',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminDashboard()),
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }
            
            final stats = snapshot.data ?? [0, 0, 0];
            
            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                final crossAxisCount = isWide ? 2 : 1;
                
                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildDashboardCard(
                      context,
                      'Manajemen Pengguna',
                      Icons.people,
                      '${stats[0]} Pengguna',
                      () => Navigator.pushNamed(context, '/users'),
                    ),
                    _buildDashboardCard(
                      context,
                      'Berita & Artikel',
                      Icons.article,
                      '${stats[1]} Artikel',
                      () => _showComingSoon(context),
                    ),
                    _buildDashboardCard(
                      context,
                      'Post Forum',
                      Icons.forum,
                      '${stats[2]} Post',
                      () => _showComingSoon(context),
                    ),
                    _buildDashboardCard(
                      context,
                      'Monitoring Kesehatan',
                      Icons.monitor_heart,
                      'Data Real-time',
                      () => _showComingSoon(context),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<int>> _getStats() async {
    try {
      final adminService = AdminService();
      final results = await Future.wait([
        adminService.getTotalUsers(),
        adminService.getTotalNews(),
        adminService.getTotalForumPosts(),
      ]);
      return results;
    } catch (e) {
      return [0, 0, 0];
    }
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      color: NeuromorphicTheme.cardBackground,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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

class SimpleUsersPage extends StatefulWidget {
  const SimpleUsersPage({super.key});

  @override
  State<SimpleUsersPage> createState() => _SimpleUsersPageState();
}

class _SimpleUsersPageState extends State<SimpleUsersPage> {
  final AdminService _adminService = AdminService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuromorphicTheme.background,
      appBar: AppBar(
        title: const Text('Manajemen Pengguna'),
        backgroundColor: NeuromorphicTheme.primary,
        foregroundColor: Colors.white,
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
                        'Daftar Pengguna',
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
            
            // Users list
            Expanded(
              child: StreamBuilder(
                stream: _adminService.getUsers(),
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
                          const Text('Gagal memuat data pengguna'),
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

                  final users = snapshot.data ?? [];
                  
                  if (users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 64,
                            color: NeuromorphicTheme.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada pengguna',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tambah data demo untuk melihat daftar pengguna',
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
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        color: NeuromorphicTheme.cardBackground,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: NeuromorphicTheme.primary,
                            child: Text(
                              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.email),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getRoleColor(user.role),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      user.role.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (!user.isActive)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'NONAKTIF',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'status',
                                child: Text(user.isActive ? 'Nonaktifkan' : 'Aktifkan'),
                              ),
                              const PopupMenuItem(
                                value: 'role',
                                child: Text('Ubah Peran'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Hapus'),
                              ),
                            ],
                            onSelected: (value) => _handleUserAction(value.toString(), user),
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

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'moderator':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  void _handleUserAction(String action, dynamic user) {
    switch (action) {
      case 'status':
        _toggleUserStatus(user);
        break;
      case 'role':
        _showChangeRoleDialog(user);
        break;
      case 'delete':
        _showDeleteUserDialog(user);
        break;
    }
  }

  void _toggleUserStatus(dynamic user) async {
    try {
      await _adminService.toggleUserStatus(user.id, !user.isActive);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              user.isActive ? 'Pengguna dinonaktifkan' : 'Pengguna diaktifkan',
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

  void _showChangeRoleDialog(dynamic user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubah Peran - ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('User'),
              onTap: () {
                Navigator.pop(context);
                _changeUserRole(user, 'user');
              },
            ),
            ListTile(
              title: const Text('Moderator'),
              onTap: () {
                Navigator.pop(context);
                _changeUserRole(user, 'moderator');
              },
            ),
            ListTile(
              title: const Text('Admin'),
              onTap: () {
                Navigator.pop(context);
                _changeUserRole(user, 'admin');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _changeUserRole(dynamic user, String newRole) async {
    try {
      await _adminService.updateUserRole(user.id, newRole);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Peran ${user.name} diubah menjadi $newRole'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengubah peran: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteUserDialog(dynamic user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pengguna'),
        content: Text(
          'Apakah Anda yakin ingin menghapus pengguna "${user.name}"? '
          'Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => _deleteUser(user),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(dynamic user) async {
    Navigator.pop(context);

    try {
      await _adminService.deleteUser(user.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pengguna ${user.name} berhasil dihapus'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus pengguna: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
