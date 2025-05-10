import 'package:flutter/material.dart';
import '../../../utils/utils.dart';
import '../../../widgets/absensi_main_button.dart';
import '../../../services/api_service.dart';

class AddAbsensiPage extends StatefulWidget {
  const AddAbsensiPage({Key? key}) : super(key: key);

  @override
  State<AddAbsensiPage> createState() => _AddAbsensiPageState();
}

class _AddAbsensiPageState extends State<AddAbsensiPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idSiswaController = TextEditingController();
  final TextEditingController _idJadwalController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _jamMasukController = TextEditingController();
  final TextEditingController _jamKeluarController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  // fotoAbsensi sementara tidak diinput manual

  bool _isSaving = false;

  @override
  void dispose() {
    _idSiswaController.dispose();
    _idJadwalController.dispose();
    _tanggalController.dispose();
    _jamMasukController.dispose();
    _jamKeluarController.dispose();
    _statusController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final absensi = {
        'id_siswa': int.parse(_idSiswaController.text.trim()),
        'id_jadwal': int.parse(_idJadwalController.text.trim()),
        'tanggal': _tanggalController.text.trim(), // format: yyyy-MM-dd
        'jam_masuk': _jamMasukController.text.trim(), // format: HH:mm:ss
        'jam_keluar': _jamKeluarController.text.trim(), // format: HH:mm:ss
        'status': _statusController.text.trim(),
        'keterangan': _keteranganController.text.trim(),
        // 'foto_absensi': null, (optional, skip upload foto di awal)
      };
      await ApiService.createAbsensi(absensi);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan absensi: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Absensi'), backgroundColor: Utils.mainThemeColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Utils.generateInputField(
                hintText: 'ID Siswa (angka)',
                iconData: Icons.person,
                controller: _idSiswaController,
                isPassword: false,
                onChanged: (_) {},
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'ID Jadwal (angka)',
                iconData: Icons.schedule,
                controller: _idJadwalController,
                isPassword: false,
                onChanged: (_) {},
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'Tanggal (yyyy-MM-dd)',
                iconData: Icons.date_range,
                controller: _tanggalController,
                isPassword: false,
                onChanged: (_) {},
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'Jam Masuk (HH:mm:ss)',
                iconData: Icons.login,
                controller: _jamMasukController,
                isPassword: false,
                onChanged: (_) {},
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'Jam Keluar (HH:mm:ss)',
                iconData: Icons.logout,
                controller: _jamKeluarController,
                isPassword: false,
                onChanged: (_) {},
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'Status (Hadir/Izin/Sakit)',
                iconData: Icons.check_circle,
                controller: _statusController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'Keterangan',
                iconData: Icons.notes,
                controller: _keteranganController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const SizedBox(height: 24),
              _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : AbsensiMainButton(label: 'Simpan', onTap: _save),
            ],
          ),
        ),
      ),
    );
  }
}
