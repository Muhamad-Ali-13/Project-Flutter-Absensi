// lib/pages/jadwal_pembelajaran_page.dart
import 'package:flutter/material.dart';
import '../../../models/jadwal_pembelajaran.dart';
import '../../../models/guru.dart';
import '../../../models/kelas.dart';
import '../../../models/mata_pelajaran.dart';
import '../../../services/api_service.dart';
import '../../../utils/utils.dart';

class JadwalPembelajaranPage extends StatefulWidget {
  const JadwalPembelajaranPage({Key? key}) : super(key: key);

  @override
  State<JadwalPembelajaranPage> createState() => _JadwalPembelajaranPageState();
}

class _JadwalPembelajaranPageState extends State<JadwalPembelajaranPage> {
  late Future<List<JadwalPembelajaran>> _futureJadwal;

  @override
  void initState() {
    super.initState();
    _loadJadwal();
  }

  void _loadJadwal() {
    _futureJadwal = ApiService.fetchJadwalPembelajarans().then(
      (list) => list.map((e) => JadwalPembelajaran.fromJson(e)).toList(),
    );
  }

  void _showDetailModal(JadwalPembelajaran jadwal) {
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
                'Hari: ${jadwal.hari}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Jam: ${jadwal.jamMulai} - ${jadwal.jamSelesai}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/edit_jadwal',
                        arguments: jadwal,
                      ).then((refresh) {
                        if (refresh == true) setState(_loadJadwal);
                      });
                    },
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDelete(jadwal.idJadwal);
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
            content: const Text(
              'Apakah Anda yakin ingin menghapus jadwal ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ApiService.deleteJadwalPembelajaran(id);
                  setState(_loadJadwal);
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
      body: FutureBuilder<List<JadwalPembelajaran>>(
        future: _futureJadwal,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final jadwalList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jadwalList.length,
            itemBuilder: (context, index) {
              final jadwal = jadwalList[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () => _showDetailModal(jadwal),
                  title: Text(
                    jadwal.hari,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${jadwal.jamMulai} - ${jadwal.jamSelesai}'),
                  trailing: const Icon(Icons.schedule),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Utils.mainThemeColor,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_jadwal');
          if (result == true) setState(_loadJadwal);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
