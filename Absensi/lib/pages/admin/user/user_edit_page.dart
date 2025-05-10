import 'package:flutter/material.dart';
import '../../../utils/utils.dart';
import '../../../widgets/absensi_main_button.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';

class EditUserPage extends StatefulWidget {
  final User user;
  const EditUserPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _roleController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user.nama);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController();
    _roleController = TextEditingController(text: widget.user.role ?? '');
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final updatedUser = User(
        idUsers: widget.user.idUsers,
        nama: _namaController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim().isEmpty ? null : _passwordController.text.trim(),
        role: _roleController.text.trim(),
      );

      await ApiService.updateUser(updatedUser.idUsers, updatedUser.toJson());
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update user: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        backgroundColor: Utils.mainThemeColor,
      ),
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
                hintText: 'Password (Kosongkan jika tidak diganti)',
                iconData: Icons.lock,
                controller: _passwordController,
                isPassword: true,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              Utils.generateInputField(
                hintText: 'Role',
                iconData: Icons.security,
                controller: _roleController,
                isPassword: false,
                onChanged: (_) {},
              ),
              const Spacer(),
              _isSaving
                  ? const CircularProgressIndicator()
                  : AbsensiMainButton(label: 'Update', onTap: _update),
            ],
          ),
        ),
      ),
    );
  }
}
