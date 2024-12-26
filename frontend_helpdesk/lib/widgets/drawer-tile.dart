import 'package:flutter/material.dart';
import 'package:frontend_helpdesk/constants/Theme.dart';

class DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback
      onTap; // Menggunakan VoidCallback untuk tipe fungsi yang lebih spesifik
  final bool isSelected;
  final Color iconColor;

  // Menambahkan required untuk parameter yang tidak boleh null
  DrawerTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
    this.iconColor = ArgonColors.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? ArgonColors.primary : ArgonColors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? ArgonColors.white : iconColor,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  letterSpacing: .3,
                  fontSize: 15,
                  color: isSelected
                      ? ArgonColors.white
                      : Color.fromRGBO(0, 0, 0, 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
