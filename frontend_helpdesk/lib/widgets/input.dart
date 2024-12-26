import 'package:flutter/material.dart';
import 'package:frontend_helpdesk/constants/Theme.dart';

class Input extends StatelessWidget {
  final String? placeholder; // Menambahkan tanda tanya untuk null safety
  final Widget? suffixIcon; // Menambahkan tanda tanya untuk null safety
  final Widget? prefixIcon; // Menambahkan tanda tanya untuk null safety
  final VoidCallback? onTap; // Mengubah tipe menjadi VoidCallback
  final ValueChanged<String>? onChanged; // Mengubah tipe menjadi ValueChanged
  final TextEditingController?
      controller; // Menambahkan tanda tanya untuk null safety
  final bool autofocus;
  final Color borderColor;

  Input({
    this.placeholder,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.onChanged,
    this.autofocus = false,
    this.borderColor = ArgonColors.border,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: ArgonColors.muted,
      onTap: onTap,
      onChanged: onChanged,
      controller: controller,
      autofocus: autofocus,
      style:
          TextStyle(height: 0.85, fontSize: 14.0, color: ArgonColors.initial),
      textAlignVertical: TextAlignVertical(y: 0.6),
      decoration: InputDecoration(
        filled: true,
        fillColor: ArgonColors.white,
        hintStyle: TextStyle(
          color: ArgonColors.muted,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: borderColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: borderColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        hintText: placeholder,
      ),
    );
  }
}
