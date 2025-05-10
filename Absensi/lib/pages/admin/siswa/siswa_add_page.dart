import 'package:flutter/material.dart';
import '../../../utils/utils.dart';
import '../../../widgets/absensi_main_button.dart';
import '../../../services/api_service.dart';

class AddSiswaPage extends StatefulWidget {
  const AddSiswaPage({Key? key}) : super(key: key);

  @override
  State<AddSiswaPage> createState() => _AddSiswaPageState();
}

class _AddSiswaPageState extends State<AddSiswaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idUsersController = TextEditingController();
  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _tanggallahirController = TextEditingController();  
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _idKelasController = TextEditingController(); // Default role
  final TextEditingController _jenisKelaminController = TextEditingController(); // Default role
  bool _isSaving = false;

  @override
  void dispose() {
    _idUsersController.dispose();
    _nisController.dispose();
    _tanggallahirController.dispose();
    _alamatController.dispose();
    _noHpController.dispose();
    _idKelasController.dispose(); // Default role
    _jenisKelaminController.dispose(); // Default role
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final siswa = {
        'id_siswa': 0, // Set 0 for the new record
        'id_users': int.parse(_idUsersController.text.trim()),   
        'nis': _nisController.text.trim(),
        'tanggallahir': _tanggallahirController.text.trim(),
        'alamat': _alamatController.text.trim(),
        'no_hp': _noHpController.text.trim(),
        'id_kelas': int.parse(_idKelasController.text.trim()), // Default role
        'jenis_kelamin': _jenisKelaminController.text.trim(), // Default role
      };
      await ApiService.createSiswa(siswa);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan siswa: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Siswa'), backgroundColor: Utils.mainThemeColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Utils.generateInputField(
                hintText: 'Nama Siswa',
                iconData: Icons.person,
                controller: _idUsersController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'NIS',
                iconData: Icons.confirmation_number,
                controller: _nisController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'tanggal lahir',
                iconData: Icons.date_range,
                controller: _tanggallahirController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'Alamat',
                iconData: Icons.home,
                controller: _alamatController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'No HP',
                iconData: Icons.phone,
                controller: _noHpController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'ID Kelas',
                iconData: Icons.class_,
                controller: _idKelasController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'Jenis Kelamin',
                iconData: Icons.people,
                controller: _jenisKelaminController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const Spacer(),
              _isSaving
                  ? const CircularProgressIndicator()
                  : AbsensiMainButton(label: 'Simpan', onTap: _save),
            ],
          ),
        ),
      ),
    );
  }
}
