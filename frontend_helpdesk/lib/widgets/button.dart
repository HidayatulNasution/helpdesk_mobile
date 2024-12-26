import 'package:flutter/material.dart';

const double defaultBorderRadius = 3.0;

class StretchableButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double borderRadius;
  final double buttonPadding;
  final Color buttonColor, splashColor;
  final Color buttonBorderColor;
  final List<Widget> children;

  StretchableButton({
    required this.buttonColor,
    required this.borderRadius,
    required this.children,
    this.splashColor = Colors.grey, // Provide a default splash color
    this.buttonBorderColor =
        Colors.transparent, // Default border color as transparent
    required this.onPressed,
    this.buttonPadding = 8.0, // Default padding
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var contents = List<Widget>.from(children);

        if (constraints.minWidth == 0) {
          contents.add(SizedBox.shrink());
        } else {
          contents.add(Spacer());
        }

        return ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(buttonColor),
            splashFactory: NoSplash.splashFactory,
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: BorderSide(color: buttonBorderColor),
              ),
            ),
            padding: MaterialStateProperty.all(EdgeInsets.all(buttonPadding)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: contents,
          ),
        );
      },
    );
  }
}
