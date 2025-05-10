// lib/pages/user_page.dart
import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';
import '../../../utils/utils.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    _futureUsers = ApiService.fetchUsers().then(
          (list) => list.map((e) => User.fromJson(e)).toList(),
    );
  }

  void _showDetailModal(User user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.nama, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(user.email, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Role: ${user.role ?? 'N/A'}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/edit_user',
                        arguments: user,
                      ).then((refresh) {
                        if (refresh == true) setState(_loadUsers);
                      });
                    },
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDelete(user.idUsers);
                    },
                    child: const Text(
                      'Hapus',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus user ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ApiService.deleteUser(id);
              setState(_loadUsers);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users = snapshot.data!;
          if (users.isEmpty) {
            return const Center(child: Text('Belum ada user'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () => _showDetailModal(user),
                  title: Text(
                    user.nama,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user.email),
                  trailing: Text(
                    user.role ?? '',
                    style: TextStyle(color: Utils.mainThemeColor),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Utils.mainThemeColor,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_user');
          if (result == true) setState(_loadUsers);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
