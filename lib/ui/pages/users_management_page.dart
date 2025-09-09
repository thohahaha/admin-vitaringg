import 'package:flutter/material.dart';
import '../theme/neuromorphic_theme.dart';
import '../theme/neuromorphic_widgets.dart';
import '../../models/user_model.dart';
import '../../services/admin_service.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
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
        title: 'Manajemen Pengguna',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header dengan search dan tombol tambah
            NeuCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NeuTextField(
                      controller: _searchController,
                      hintText: 'Cari pengguna...', 
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
                    const SizedBox(height: 16),
                    NeuButton(
                      onPressed: () => _showSeedDataDialog(),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.dataset, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Tambah Data Demo'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stats cards
            StreamBuilder<List<UserModel>>(
              stream: _adminService.getUsers(),
              builder: (context, snapshot) {
                final users = snapshot.data ?? [];
                final adminCount =
                    users.where((u) => u.role == 'admin').length;
                final moderatorCount =
                    users.where((u) => u.role == 'moderator').length;
                final activeUsers = users.where((u) => u.isActive).length;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < 600;
                    
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildStatCard(
                          'Total Pengguna',
                          users.length.toString(),
                          Icons.people,
                          NeuromorphicTheme.primary,
                          isMobile,
                        ),
                        _buildStatCard(
                          'Pengguna Aktif',
                          activeUsers.toString(),
                          Icons.check_circle,
                          NeuromorphicTheme.success,
                          isMobile,
                        ),
                        _buildStatCard(
                          'Admin & Moderator',
                          (adminCount + moderatorCount).toString(),
                          Icons.admin_panel_settings,
                          NeuromorphicTheme.warning,
                          isMobile,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // Daftar pengguna
            Expanded(
              child: NeuCard(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            'Daftar Pengguna',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Spacer(),
                          StreamBuilder<List<UserModel>>(
                            stream: _adminService.getUsers(),
                            builder: (context, snapshot) {
                              final count = snapshot.data?.length ?? 0;
                              return Text(
                                '$count total',
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
                    Expanded(
                      child: StreamBuilder<List<UserModel>>(
                        stream: _adminService.getUsers(),
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
                                    'Gagal memuat data pengguna',
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
                                  const SizedBox(height: 16),
                                  NeuButton(
                                    onPressed: () => _showSeedDataDialog(),
                                    child: const Text('Tambah Data Demo'),
                                  ),
                                ],
                              ),
                            );
                          }

                          final allUsers = snapshot.data ?? [];
                          final filteredUsers = allUsers.where((user) {
                            if (_searchQuery.isEmpty) return true;
                            return user.name
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                user.email
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                user.role
                                    .toLowerCase()
                                    .contains(_searchQuery);
                          }).toList();

                          if (filteredUsers.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 64,
                                    color: NeuromorphicTheme.textSecondary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'Tidak ada pengguna yang ditemukan'
                                        : 'Belum ada pengguna',
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
                                          : 'Tambah data demo untuk melihat daftar pengguna',
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
                                  if (_searchQuery.isEmpty) ...[
                                    const SizedBox(height: 16),
                                    NeuButton(
                                      onPressed: () => _showSeedDataDialog(),
                                      child: const Text('Tambah Data Demo'),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }

                          return LayoutBuilder(
                            builder: (context, constraints) {
                              final isMobile = constraints.maxWidth < 600;
                              
                              if (isMobile) {
                                return ListView.builder(
                                  itemCount: filteredUsers.length,
                                  itemBuilder: (context, index) {
                                    final user = filteredUsers[index];
                                    return _buildUserItem(user);
                                  },
                                );
                              } else {
                                return SingleChildScrollView(
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('Nama')),
                                      DataColumn(label: Text('Email')),
                                      DataColumn(label: Text('Peran')),
                                      DataColumn(label: Text('Status')),
                                      DataColumn(label: Text('Aksi')),
                                    ],
                                    rows: filteredUsers
                                        .map((user) => DataRow(
                                              cells: [
                                                DataCell(Text(user.name)),
                                                DataCell(Text(user.email)),
                                                DataCell(Text(user.role)),
                                                DataCell(Text(
                                                    user.isActive ? 'Aktif' : 'Nonaktif')),
                                                DataCell(
                                                  PopupMenuButton(
                                                    icon: const Icon(Icons.more_vert),
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        value: 'toggle_status',
                                                        child: Text(user.isActive
                                                            ? 'Nonaktifkan'
                                                            : 'Aktifkan'),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 'change_role',
                                                        child: Text('Ubah Peran'),
                                                      ),
                                                      const PopupMenuItem(
                                                        value: 'delete',
                                                        child: Text('Hapus'),
                                                      ),
                                                    ],
                                                    onSelected: (value) {
                                                      switch (value) {
                                                        case 'toggle_status':
                                                          _toggleUserStatus(user);
                                                          break;
                                                        case 'change_role':
                                                          _showChangeRoleDialog(user);
                                                          break;
                                                        case 'delete':
                                                          _showDeleteUserDialog(user);
                                                          break;
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    final cardWidth = isMobile ? null : 150.0;
    
    return SizedBox(
      width: cardWidth,
      child: NeuCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserItem(UserModel user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: NeuromorphicTheme.cardBackground,
      ),
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
                const SizedBox(width: 8),
                Text(
                  'Bergabung ${_formatDate(user.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle_status',
              child: Row(
                children: [
                  Icon(
                    user.isActive ? Icons.block : Icons.check_circle,
                    size: 16,
                    color: user.isActive ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.isActive ? 'Nonaktifkan' : 'Aktifkan',
                    style: TextStyle(
                      color: user.isActive ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'change_role',
              child: Row(
                children: [
                  Icon(Icons.admin_panel_settings, size: 16),
                  SizedBox(width: 8),
                  Text('Ubah Peran'),
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
          onSelected: (value) {
            switch (value) {
              case 'toggle_status':
                _toggleUserStatus(user);
                break;
              case 'change_role':
                _showChangeRoleDialog(user);
                break;
              case 'delete':
                _showDeleteUserDialog(user);
                break;
            }
          },
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _toggleUserStatus(UserModel user) async {
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

  void _showChangeRoleDialog(UserModel user) {
    String newRole = user.role;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubah Peran - ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('User'),
              value: 'user',
              groupValue: newRole,
              onChanged: (value) {
                setState(() {
                  newRole = value!;
                });
                Navigator.pop(context);
                _changeUserRole(user, newRole);
              },
            ),
            RadioListTile<String>(
              title: const Text('Moderator'),
              value: 'moderator',
              groupValue: newRole,
              onChanged: (value) {
                setState(() {
                  newRole = value!;
                });
                Navigator.pop(context);
                _changeUserRole(user, newRole);
              },
            ),
            RadioListTile<String>(
              title: const Text('Admin'),
              value: 'admin',
              groupValue: newRole,
              onChanged: (value) {
                setState(() {
                  newRole = value!;
                });
                Navigator.pop(context);
                _changeUserRole(user, newRole);
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

  void _changeUserRole(UserModel user, String newRole) async {
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

  void _showDeleteUserDialog(UserModel user) {
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

  void _deleteUser(UserModel user) async {
    Navigator.pop(context); // Tutup dialog

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

  void _showSeedDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Data Demo'),
        content: const Text(
          'Ini akan menambahkan beberapa data pengguna demo ke Firebase Firestore. '
          'Data ini berguna untuk testing dan pengembangan.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => _seedDummyData(),
            child: const Text('Tambah Data'),
          ),
        ],
      ),
    );
  }

  void _seedDummyData() async {
    Navigator.pop(context); // Tutup dialog

    try {
      await _adminService.seedDummyData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data demo berhasil ditambahkan!'),
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
