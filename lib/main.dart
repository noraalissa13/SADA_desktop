import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada_desktop/pages/homepage.dart';
import 'package:sada_desktop/providers/device_connection_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DeviceConnectionState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SADA',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        //'/session report': (context) => const SessionReportPage(),
        //'/learning strategies': (context) => const LearningStrategyPage(),
        //'/music feedback': (context) => const FeedbackPage(),
      },
    );
  }
}

class AppColors {
  static const primaryColor = Color.fromARGB(132, 80, 227, 195);
  static const secondaryColor = Color(0xFF50E3C2);
  static const scaffoldBackground = Color.fromARGB(255, 222, 230, 232);
  static const textColor = Color(0xFF333333);
  static const buttonColor = Color(0xFF00A89E);
  static const highlightColor = Color.fromARGB(100, 80, 227, 195);
  static const dividerColor = Color.fromARGB(100, 80, 227, 195);
}

class AppTextStyles {
  static const textStyle = TextStyle(color: AppColors.textColor);
}

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.secondaryColor,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    textTheme: const TextTheme(
      bodyLarge: AppTextStyles.textStyle,
      bodyMedium: AppTextStyles.textStyle,
      displayLarge: AppTextStyles.textStyle,
    ),
    appBarTheme: const AppBarTheme(color: Colors.transparent),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.buttonColor,
      textTheme: ButtonTextTheme.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: Colors.black,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
    ),
    highlightColor: AppColors.highlightColor,
    dividerColor: AppColors.dividerColor,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryColor,
      onPrimary: Colors.white,
      secondary: AppColors.secondaryColor,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.textColor,
      error: Colors.red,
      onError: Colors.white,
    ),
  );
}
