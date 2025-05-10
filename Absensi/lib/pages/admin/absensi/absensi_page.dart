// lib/pages/absensi_page.dart
import 'package:flutter/material.dart';
import '../../../models/absensi.dart';
import '../../../services/api_service.dart';
import '../../../utils/utils.dart';

class AbsensiPage extends StatefulWidget {
  const AbsensiPage({Key? key}) : super(key: key);

  @override
  State<AbsensiPage> createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  late Future<List<Absensi>> _futureAbsensi;

  @override
  void initState() {
    super.initState();
    _loadAbsensi();
  }

  void _loadAbsensi() {
    _futureAbsensi = ApiService.fetchAbsensi().then(
      (list) => list.map((e) => Absensi.fromJson(e)).toList(),
    );
  }

  void _showDetailModal(Absensi absensi) {
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
                'Status: ${absensi.status}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Tanggal: ${Utils.formatTanggal(absensi.tanggal)}'),
              const SizedBox(height: 8),
              Text('Jam Masuk: ${Utils.formatJam(absensi.jamMasuk)}'),
              const SizedBox(height: 8),
              Text('Jam Keluar: ${Utils.formatJam(absensi.jamKeluar)}'),
              const SizedBox(height: 8),
              Text('Keterangan: ${absensi.keterangan}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/edit_absensi',
                        arguments: absensi,
                      ).then((refresh) {
                        if (refresh == true) setState(_loadAbsensi);
                      });
                    },
                    child: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmDelete(absensi.id);
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
              'Apakah Anda yakin ingin menghapus absensi ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await ApiService.deleteAbsensi(id);
                  setState(_loadAbsensi);
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
      body: FutureBuilder<List<Absensi>>(
        future: _futureAbsensi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final absensiList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: absensiList.length,
            itemBuilder: (context, index) {
              final absensi = absensiList[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  onTap: () => _showDetailModal(absensi),
                  title: Text(
                    absensi.status,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(Utils.formatTanggal(absensi.tanggal)),
                  trailing: const Icon(Icons.event_available),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Utils.mainThemeColor,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_absensi');
          if (result == true) setState(_loadAbsensi);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
