import 'package:flutter/material.dart';
import '../../../utils/utils.dart';
import '../../../widgets/absensi_main_button.dart';
import '../../../models/absensi.dart';
import '../../../services/api_service.dart';

class EditAbsensiPage extends StatefulWidget {
  final Absensi absensi;
  const EditAbsensiPage({Key? key, required this.absensi}) : super(key: key);

  @override
  State<EditAbsensiPage> createState() => _EditAbsensiPageState();
}

class _EditAbsensiPageState extends State<EditAbsensiPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _statusController;
  late TextEditingController _keteranganController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _statusController = TextEditingController(text: widget.absensi.status);
    _keteranganController = TextEditingController(text: widget.absensi.keterangan);
  }

  @override
  void dispose() {
    _statusController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final absensi = Absensi(
        id: widget.absensi.id,
        idSiswa: widget.absensi.idSiswa,
        idJadwal: widget.absensi.idJadwal,
        tanggal: widget.absensi.tanggal,
        jamMasuk: widget.absensi.jamMasuk,
        jamKeluar: widget.absensi.jamKeluar,
        status: _statusController.text.trim(),
        fotoAbsensi: widget.absensi.fotoAbsensi,
        keterangan: _keteranganController.text.trim(),
      );
      await ApiService.updateAbsensi(absensi.id, absensi.toJson());
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update absensi: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Absensi'),
        backgroundColor: Utils.mainThemeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Utils.generateInputField(hintText: 'Status', iconData: Icons.check_circle, controller: _statusController, isPassword: false, onChanged: (_) {}),
              const SizedBox(height: 12),
              Utils.generateInputField(hintText: 'Keterangan', iconData: Icons.notes, controller: _keteranganController, isPassword: false, onChanged: (_) {}),
              const Spacer(),
              _isSaving ? const CircularProgressIndicator() : AbsensiMainButton(label: 'Update', onTap: _update),
            ],
          ),
        ),
      ),
    );
  }
}
