// MADE BY: NORA ALISSA BINTI ISMAIL (2117862)
// This file contains the main entry point of the application,
// as well as the main application widget and classes for defining custom app colors, text styles, and themes.
import 'package:flutter/material.dart'; // Importing Material Design package for UI components
import 'package:provider/provider.dart'; // Importing provider for state management
import 'package:sada_desktop/pages/homepage.dart'; // Importing the HomePage widget
import 'package:sada_desktop/providers/device_connection_state.dart'; // Importing the device connection state provider
import 'package:sada_desktop/pages/connect_device.dart'; // Importing the ConnectDevicePage widget

// The main entry point of the application
void main() {
  runApp(
    // Wrapping the app with ChangeNotifierProvider to manage device connection state
    ChangeNotifierProvider(
      create: (context) =>
          DeviceConnectionState(), // Creating the provider for device connection state
      child: MyApp(), // Passing the app widget to the provider
    ),
  );
}

// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor for the MyApp widget

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SADA', // Title of the app
      debugShowCheckedModeBanner:
          false, // Disabling the debug banner in the app
      theme: AppThemes
          .lightTheme, // Setting the app's theme to the light theme defined in AppThemes
      home:
          const HomePage(), // Setting the home page of the app to the HomePage widget
      routes: {
        '/home': (context) =>
            const HomePage(), // Defining the route for the home page
        '/connect_device': (context) =>
            const ConnectDevicePage(), // Defining the route for the connect device page
      },
    );
  }
}

// A class for defining custom app colors
class AppColors {
  static const primaryColor =
      Color.fromARGB(132, 80, 227, 195); // Primary color used in the app
  static const secondaryColor =
      Color(0xFF50E3C2); // Secondary color used in the app
  static const scaffoldBackground = Color.fromARGB(
      255, 222, 230, 232); // Background color for the scaffold (main body)
  static const textColor = Color(0xFF333333); // Default text color
  static const buttonColor = Color(0xFF00A89E); // Color for buttons
  static const highlightColor =
      Color.fromARGB(100, 80, 227, 195); // Color for highlighting elements
  static const dividerColor =
      Color.fromARGB(100, 80, 227, 195); // Color for dividers
}

// A class for defining text styles used in the app
class AppTextStyles {
  static const textStyle = TextStyle(
      color:
          AppColors.textColor); // Default text style with the app's text color
}

// A class for defining app themes, such as colors, button styles, and text styles
class AppThemes {
  static ThemeData lightTheme = ThemeData(
    primaryColor:
        AppColors.primaryColor, // Setting the primary color for the app
    hintColor: AppColors.secondaryColor, // Color for hints and placeholders
    scaffoldBackgroundColor:
        AppColors.scaffoldBackground, // Background color for the scaffold
    textTheme: const TextTheme(
      bodyLarge: AppTextStyles
          .textStyle, // Applying the default text style to body text
      bodyMedium: AppTextStyles
          .textStyle, // Applying the default text style to medium body text
      displayLarge: AppTextStyles
          .textStyle, // Applying the default text style to large display text
    ),
    appBarTheme: const AppBarTheme(
        color: Colors.transparent), // Setting app bar to be transparent
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.buttonColor, // Button color
      textTheme: ButtonTextTheme.primary, // Button text theme
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: Colors.black), // Style for TextButton (black text)
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            AppColors.buttonColor, // Background color for ElevatedButton
        foregroundColor: Colors.black, // Text color for ElevatedButton
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black), // Text color for OutlinedButton
    ),
    highlightColor: AppColors.highlightColor, // Color for highlighting elements
    dividerColor: AppColors.dividerColor, // Color for dividers
    colorScheme: const ColorScheme(
      brightness: Brightness.light, // Setting the brightness to light
      primary: AppColors.primaryColor, // Primary color for the color scheme
      onPrimary: Colors.white, // Text color on primary elements
      secondary:
          AppColors.secondaryColor, // Secondary color for the color scheme
      onSecondary: Colors.white, // Text color on secondary elements
      surface: Colors.white, // Color for surface elements (e.g., cards)
      onSurface: AppColors.textColor, // Text color on surface elements
      error: Colors.red, // Error color
      onError: Colors.white, // Text color on error elements
    ),
  );
}
