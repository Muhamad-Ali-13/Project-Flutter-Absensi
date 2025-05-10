// lib/pages/kelas_page.dart
import 'package:flutter/material.dart';
import '../../../models/kelas.dart';
import '../../../services/api_service.dart';
import '../../../utils/utils.dart';

class KelasPage extends StatefulWidget {
  const KelasPage({Key? key}) : super(key: key);

  @override
  State<KelasPage> createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  late Future<List<Kelas>> _futureKelas;

  @override
  void initState() {
    super.initState();
    _loadKelas();
  }

  void _loadKelas() {
    _futureKelas = ApiService.fetchKelas().then(
      (list) => list.map((e) => Kelas.fromJson(e)).toList(),
    );
  }

  void _showDetailModal(Kelas kelas) {
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
              Text(
                kelas.namaKelas,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('ID Guru: ${kelas.idGuru ?? 'Belum ada wali kelas'}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/edit_kelas',
                        arguments: kelas,
                      ).then((refresh) {
                        if (refresh == true) setState(_loadKelas);
                      });
                    },
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDelete(kelas.idKelas);
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
            content: const Text('Apakah Anda yakin ingin menghapus kelas ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ApiService.deleteKelas(id);
                  setState(_loadKelas);
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
      body: FutureBuilder<List<Kelas>>(
        future: _futureKelas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final kelasList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: kelasList.length,
            itemBuilder: (context, index) {
              final kelas = kelasList[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () => _showDetailModal(kelas),
                  title: Text(
                    kelas.namaKelas,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('ID Guru: ${kelas.idGuru ?? 'Belum ada'}'),
                  trailing: const Icon(Icons.class_),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Utils.mainThemeColor,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_kelas');
          if (result == true) setState(_loadKelas);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
