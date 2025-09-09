import 'package:flutter/material.dart';
import '../theme/neuromorphic_theme.dart';
import '../../services/admin_service.dart';

class HealthManagementPage extends StatefulWidget {
  const HealthManagementPage({super.key});

  @override
  State<HealthManagementPage> createState() => _HealthManagementPageState();
}

class _HealthManagementPageState extends State<HealthManagementPage> {
  final AdminService _adminService = AdminService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeuromorphicTheme.background,
      appBar: AppBar(
        title: const Text('Monitoring Kesehatan'),
        backgroundColor: NeuromorphicTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _showHealthAnalytics,
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
                        'Data Kesehatan Pengguna',
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
            
            // Health Stats Cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.blue.withOpacity(0.1),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.people, color: Colors.blue, size: 32),
                          SizedBox(height: 8),
                          Text('Total Pengguna', style: TextStyle(fontSize: 12)),
                          Text('245', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    color: Colors.green.withOpacity(0.1),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.favorite, color: Colors.green, size: 32),
                          SizedBox(height: 8),
                          Text('Data Aktif', style: TextStyle(fontSize: 12)),
                          Text('189', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    color: Colors.orange.withOpacity(0.1),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(Icons.warning, color: Colors.orange, size: 32),
                          SizedBox(height: 8),
                          Text('Perlu Perhatian', style: TextStyle(fontSize: 12)),
                          Text('12', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Health data list
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
                          const Text('Gagal memuat data kesehatan'),
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

                  final users = snapshot.data as List? ?? [];
                  
                  if (users.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.health_and_safety_outlined,
                            size: 64,
                            color: NeuromorphicTheme.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada data kesehatan',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tambah data demo untuk melihat monitoring kesehatan',
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
                            backgroundColor: _getHealthStatusColor(_getHealthStatus(index)),
                            child: Icon(
                              _getHealthStatusIcon(_getHealthStatus(index)),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.monitor_heart, size: 16, color: Colors.red[300]),
                                  const SizedBox(width: 4),
                                  Text('HR: ${72 + (index % 20)} bpm'),
                                  const SizedBox(width: 16),
                                  Icon(Icons.thermostat, size: 16, color: Colors.blue[300]),
                                  const SizedBox(width: 4),
                                  Text('${36.5 + (index % 10) * 0.1}°C'),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.directions_walk, size: 16, color: Colors.green[300]),
                                  const SizedBox(width: 4),
                                  Text('${5000 + (index * 500)} langkah'),
                                  const SizedBox(width: 16),
                                  Icon(Icons.battery_charging_full, size: 16, color: Colors.orange[300]),
                                  const SizedBox(width: 4),
                                  Text('${85 + (index % 15)}%'),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getHealthStatusColor(_getHealthStatus(index)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getHealthStatus(index).toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'view',
                                child: Text('Lihat Detail'),
                              ),
                              const PopupMenuItem(
                                value: 'alert',
                                child: Text('Set Alert'),
                              ),
                              const PopupMenuItem(
                                value: 'export',
                                child: Text('Export Data'),
                              ),
                            ],
                            onSelected: (value) => _handleHealthAction(value.toString(), user),
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

  String _getHealthStatus(int index) {
    switch (index % 3) {
      case 0:
        return 'normal';
      case 1:
        return 'warning';
      default:
        return 'critical';
    }
  }

  Color _getHealthStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return Colors.green;
      case 'warning':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getHealthStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'critical':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  void _handleHealthAction(String action, dynamic user) {
    switch (action) {
      case 'view':
        _showHealthDetails(user);
        break;
      case 'alert':
        _showSetAlertDialog(user);
        break;
      case 'export':
        _exportHealthData(user);
        break;
    }
  }

  void _showHealthDetails(dynamic user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detail Kesehatan - ${user.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user.email}'),
            Text('Detak Jantung: ${72 + (user.hashCode % 20)} bpm'),
            Text('Suhu Tubuh: ${36.5 + (user.hashCode % 10) * 0.1}°C'),
            Text('Langkah: ${5000 + (user.hashCode % 5000)}'),
            Text('Level Baterai: ${85 + (user.hashCode % 15)}%'),
            Text('Status: ${user.isActive ? "Aktif" : "Nonaktif"}'),
            Text('Update Terakhir: Hari ini'),
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

  void _showSetAlertDialog(dynamic user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Alert'),
        content: Text('Fitur pengaturan alert untuk ${user.name} akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _exportHealthData(dynamic user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Text('Fitur export data kesehatan untuk ${user.name} akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHealthAnalytics() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Analytics Kesehatan'),
        content: const Text('Fitur analytics akan segera tersedia.'),
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
