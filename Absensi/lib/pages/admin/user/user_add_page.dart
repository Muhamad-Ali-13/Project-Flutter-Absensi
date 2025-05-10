import 'package:flutter/material.dart';
import '../../../utils/utils.dart';
import '../../../widgets/absensi_main_button.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController(); // Default role
  bool _isSaving = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose(); // Default role
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final user = {
        'id_users': 0, // Set 0 for the new record
        'nama': _namaController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'role': _roleController.text.trim(), 
      };
      await ApiService.createUser(user);
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan user: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah User'), backgroundColor: Utils.mainThemeColor),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Utils.generateInputField(
                hintText: 'Nama',
                iconData: Icons.person,
                controller: _namaController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'Email',
                iconData: Icons.email,
                controller: _emailController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'Password',
                iconData: Icons.lock,
                controller: _passwordController,
                isPassword: true,
                onChanged: (_) {},
              ),
                  const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'Role',
                iconData: Icons.lock,
                controller: _roleController,
                isPassword: true,
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
