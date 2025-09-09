import 'package:flutter/material.dart';
import '../admin_scaffold.dart';
import '../admin_drawer.dart';

class UsersPage extends StatelessWidget {
  final List<dynamic> userList;
  final void Function(dynamic user)? onChangeRole;
  final void Function(dynamic user)? onDeleteUser;

  const UsersPage({
    super.key,
    required this.userList,
    this.onChangeRole,
    this.onDeleteUser,
  });

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Pengguna',
      drawer: AdminDrawer(selected: 'users', onSelect: (v) {}),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: userList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final user = userList[i];
              return ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                tileColor: Colors.white,
                leading: const Icon(Icons.person, color: Colors.orange),
                title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<String>(
                      value: user.role,
                      items: const [
                        DropdownMenuItem(value: 'user', child: Text('User')),
                        DropdownMenuItem(value: 'admin', child: Text('Admin')),
                      ],
                      onChanged: (v) {
                        if (v != null && v != user.role) {
                          onChangeRole?.call({...user, 'role': v});
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDeleteUser?.call(user),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
