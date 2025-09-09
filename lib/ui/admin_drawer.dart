import 'package:flutter/material.dart';
import 'neuromorphic_theme.dart';

class AdminDrawer extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;
  const AdminDrawer({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: NeuromorphicTheme.background,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 32),
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.admin_panel_settings, size: 48, color: NeuromorphicTheme.accent),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Vita Ring Admin',
                    style: TextStyle(
                      color: NeuromorphicTheme.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.dashboard, 'Dashboard', 'dashboard'),
          _drawerItem(Icons.article, 'Berita', 'news'),
          _drawerItem(Icons.forum, 'Forum', 'forum'),
          _drawerItem(Icons.people, 'Pengguna', 'users'),
          _drawerItem(Icons.monitor_heart, 'Kesehatan', 'health'),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: selected == value ? NeuromorphicTheme.accent : NeuromorphicTheme.text),
      title: Text(label, style: TextStyle(color: selected == value ? NeuromorphicTheme.accent : NeuromorphicTheme.text)),
      selected: selected == value,
      selectedTileColor: NeuromorphicTheme.accent.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onTap: () => onSelect(value),
    );
  }
}
