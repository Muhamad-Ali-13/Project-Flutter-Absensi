import 'package:flutter/material.dart';

abstract class Utils {
  static const Color mainThemeColor = Color(0xFFFF0000);

  static String formatTanggal(DateTime tanggal) {
    // Example implementation: format the date as 'dd-MM-yyyy'
    return '${tanggal.day.toString().padLeft(2, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.year}';
  }

  static String formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  static String formatJam(DateTime? jam) {
    if (jam == null) return '-';
    return '${jam.hour.toString().padLeft(2, '0')}:${jam.minute.toString().padLeft(2, '0')}';
  }

  /// Generate a TextFormField with consistent styling and optional validator.
  static Widget generateInputField({
    required String hintText,
    required IconData iconData,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      obscuringCharacter: '*',
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(iconData),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }
}
