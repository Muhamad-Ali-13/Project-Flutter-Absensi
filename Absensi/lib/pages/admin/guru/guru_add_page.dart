import 'package:flutter/material.dart';
import '../../../models/guru.dart';
import '../../../services/api_service.dart';

class GuruAddPage extends StatefulWidget {
  const GuruAddPage({super.key});

  @override
  State<GuruAddPage> createState() => _GuruAddPageState();
}

class _GuruAddPageState extends State<GuruAddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idUsersController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  String? _selectedGender;

  void saveGuru() async {
    if (_formKey.currentState!.validate()) {
      final guru = Guru(
        idGuru: 0,
        idUsers: int.parse(_idUsersController.text),
        nip: _nipController.text,
        jenisKelamin: _selectedGender ?? '',
        noHp: _noHpController.text.isEmpty ? null : _noHpController.text,
      );

      try {
        await ApiService.createGuru(guru.toJson());
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guru berhasil ditambahkan')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menambahkan guru: $e')),
          );
        }
      }
    }
  }

  InputDecoration _inputDecoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Guru')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idUsersController,
                decoration: _inputDecoration(label: 'Nama (ID Users)', icon: Icons.person),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'ID Users harus diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nipController,
                decoration: _inputDecoration(label: 'NIP', icon: Icons.badge),
                validator: (value) => value == null || value.isEmpty ? 'NIP harus diisi' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: _inputDecoration(label: 'Jenis Kelamin', icon: Icons.transgender),
                items: const [
                  DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Jenis Kelamin harus dipilih' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noHpController,
                decoration: _inputDecoration(label: 'No HP', icon: Icons.phone),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: saveGuru,
                  label: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
