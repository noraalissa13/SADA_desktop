// MADE BY: NORA ALISSA BINTI ISMAIL (2117862)
// This file contains the ButtonWidget class,
// which is a custom widget for creating circular buttons with custom colors and text.

import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  // The text to display on the button
  final String text;

  // The callback function to be executed when the button is clicked
  final VoidCallback onClicked;

  // The background color of the button (default is black)
  final Color backgroundColor;

  // The text color of the button (default is white)
  final Color color;

  // Constructor for the ButtonWidget class, with required parameters for text and onClicked.
  // backgroundColor and color are optional with default values.
  const ButtonWidget({
    required this.text, // The text displayed on the button
    required this.onClicked, // The function to be executed when the button is pressed
    this.backgroundColor = Colors.black, // Default background color is black
    this.color = Colors.white, // Default text color is white
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // The build method is used to construct the widget UI
    return ElevatedButton(
      // Customizing the button style using ElevatedButton.styleFrom
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor, // Sets the background color of the button
        shape: const CircleBorder(), // Makes the button circular
        padding: const EdgeInsets.all(
            100), // Adjusts the size of the button by setting padding
        shadowColor: Colors.black, // Sets the shadow color for the button
        elevation: 10, // Adds elevation to give a 3D effect
      ),
      onPressed:
          onClicked, // Executes the onClicked function when the button is pressed
      child: Text(
        text, // Displays the text passed to the widget
        style: TextStyle(
          fontSize: 40, // Sets the font size of the text
          color: color, // Sets the color of the text
        ),
      ),
    );
  }
}
