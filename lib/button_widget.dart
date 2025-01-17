import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color backgroundColor;
  final Color color;

  const ButtonWidget({
    required this.text,
    required this.onClicked,
    this.backgroundColor = Colors.black, // Change this color to match the theme
    this.color = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const CircleBorder(), // Makes the button circular
        padding: const EdgeInsets.all(100), // Adjusts the size of the button
        shadowColor: Colors.black,
        elevation: 10,
      ),
      onPressed: onClicked,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 40,
          color: color,
        ),
      ),
    );
  }
}
