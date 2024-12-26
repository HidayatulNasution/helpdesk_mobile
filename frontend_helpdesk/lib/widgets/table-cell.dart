import 'package:flutter/material.dart';

import 'package:frontend_helpdesk/constants/Theme.dart';

class TableCellSettings extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTap;

  const TableCellSettings({
    required this.title,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: ArgonColors.text)),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.arrow_forward_ios,
                color: ArgonColors.text,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
