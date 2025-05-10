// lib/pages/siswa_page.dart
import 'package:flutter/material.dart';
import '../../../models/siswa.dart';
import '../../../services/api_service.dart';
import '../../../utils/utils.dart';

class SiswaPage extends StatefulWidget {
  const SiswaPage({Key? key}) : super(key: key);

  @override
  State<SiswaPage> createState() => _SiswaPageState();
}

class _SiswaPageState extends State<SiswaPage> {
  late Future<List<Siswa>> _futureSiswa;

  @override
  void initState() {
    super.initState();
    _loadSiswa();
  }

  void _loadSiswa() {
    _futureSiswa = ApiService.fetchSiswas().then(
      (list) => list.map((e) => Siswa.fromJson(e)).toList(),
    );
  }

  void _showDetailModal(Siswa siswa) {
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
              Text(siswa.nis, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Alamat: ${siswa.alamat}'),
              Text('No HP: ${siswa.noHp}'),
              Text('Jenis Kelamin: ${siswa.jenisKelamin}'),
              Text('Tanggal Lahir: ${Utils.formatTanggal(siswa.tanggalLahir)}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/edit_siswa',
                        arguments: siswa,
                      ).then((refresh) {
                        if (refresh == true) setState(_loadSiswa);
                      });
                    },
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDelete(siswa.idSiswa);
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
            content: const Text('Apakah Anda yakin ingin menghapus siswa ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ApiService.deleteSiswa(id);
                  setState(_loadSiswa);
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
      body: FutureBuilder<List<Siswa>>(
        future: _futureSiswa,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final siswaList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: siswaList.length,
            itemBuilder: (context, index) {
              final siswa = siswaList[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () => _showDetailModal(siswa),
                  title: Text(
                    siswa.nis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(siswa.alamat),
                  trailing: Text(
                    siswa.jenisKelamin,
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
          final result = await Navigator.pushNamed(context, '/add_siswa');
          if (result == true) setState(_loadSiswa);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
