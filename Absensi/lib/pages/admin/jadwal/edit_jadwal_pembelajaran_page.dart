import 'package:flutter/material.dart';
import '../../../utils/utils.dart';
import '../../../widgets/absensi_main_button.dart';
import '../../../models/jadwal_pembelajaran.dart';
import '../../../services/api_service.dart';

class EditJadwalPembelajaranPage extends StatefulWidget {
  final JadwalPembelajaran jadwal;
  const EditJadwalPembelajaranPage({Key? key, required this.jadwal}) : super(key: key);

  @override
  State<EditJadwalPembelajaranPage> createState() => _EditJadwalPembelajaranPageState();
}

class _EditJadwalPembelajaranPageState extends State<EditJadwalPembelajaranPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _hariController;
  late TextEditingController _jamMulaiController;
  late TextEditingController _jamSelesaiController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _hariController = TextEditingController(text: widget.jadwal.hari);
    _jamMulaiController = TextEditingController(text: widget.jadwal.jamMulai);
    _jamSelesaiController = TextEditingController(text: widget.jadwal.jamSelesai);
  }

  @override
  void dispose() {
    _hariController.dispose();
    _jamMulaiController.dispose();
    _jamSelesaiController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final jadwal = JadwalPembelajaran(
        idJadwal: widget.jadwal.idJadwal,
        idGuru: widget.jadwal.idGuru,
        idKelas: widget.jadwal.idKelas,
        idMapel: widget.jadwal.idMapel,
        hari: _hariController.text.trim(),
        jamMulai: _jamMulaiController.text.trim(),
        jamSelesai: _jamSelesaiController.text.trim(),
      );
      await ApiService.updateJadwalPembelajaran(jadwal.idJadwal, jadwal.toJson());
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update jadwal: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Jadwal Pembelajaran'),
        backgroundColor: Utils.mainThemeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Utils.generateInputField(hintText: 'Hari', iconData: Icons.calendar_today, controller: _hariController, isPassword: false, onChanged: (_) {}),
              const SizedBox(height: 12),
              Utils.generateInputField(hintText: 'Jam Mulai (HH:MM:SS)', iconData: Icons.access_time, controller: _jamMulaiController, isPassword: false, onChanged: (_) {}),
              const SizedBox(height: 12),
              Utils.generateInputField(hintText: 'Jam Selesai (HH:MM:SS)', iconData: Icons.access_time_filled, controller: _jamSelesaiController, isPassword: false, onChanged: (_) {}),
              const Spacer(),
              _isSaving ? const CircularProgressIndicator() : AbsensiMainButton(label: 'Update', onTap: _update),
            ],
          ),
        ),
      ),
    );
  }
}
