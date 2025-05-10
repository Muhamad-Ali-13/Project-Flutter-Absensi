// lib/pages/guru_page.dart
import 'package:flutter/material.dart';
import '../../../models/guru.dart';
import '../../../services/api_service.dart';
import '../../../utils/utils.dart';

class GuruPage extends StatefulWidget {
  const GuruPage({Key? key}) : super(key: key);

  @override
  State<GuruPage> createState() => _GuruPageState();
}

class _GuruPageState extends State<GuruPage> {
  late Future<List<Guru>> _futureGuru;

  @override
  void initState() {
    super.initState();
    _loadGuru();
  }

  void _loadGuru() {
    _futureGuru = ApiService.fetchGurus().then(
      (list) => list.map((e) => Guru.fromJson(e)).toList(),
    );
  }

  void _showDetailModal(Guru guru) {
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
              Text(guru.nip, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Jenis Kelamin: ${guru.jenisKelamin}'),
              if (guru.noHp != null) Text('No HP: ${guru.noHp}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/edit_guru',
                        arguments: guru,
                      ).then((refresh) {
                        if (refresh == true) setState(_loadGuru);
                      });
                    },
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDelete(guru.idGuru);
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
      builder:
          (_) => AlertDialog(
            title: const Text('Konfirmasi Hapus'),
            content: const Text('Apakah Anda yakin ingin menghapus guru ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ApiService.deleteGuru(id);
                  setState(_loadGuru);
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
      body: FutureBuilder<List<Guru>>(
        future: _futureGuru,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final guruList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: guruList.length,
            itemBuilder: (context, index) {
              final guru = guruList[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () => _showDetailModal(guru),
                  title: Text(
                    guru.nip,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Jenis Kelamin: ${guru.jenisKelamin}'),
                  trailing: const Icon(Icons.person),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Utils.mainThemeColor,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_guru');
          if (result == true) setState(_loadGuru);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
