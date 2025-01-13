import 'package:assentify_demo_app/views/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(const Color(0xFF2782FD)),
            fillColor: MaterialStateProperty.all(const Color(0xFFFCFCFC)),
            side: const BorderSide(color: Color(0xFF2782FD)),
          ),
          elevatedButtonTheme: _elevatedButtonThemeData(),
          inputDecorationTheme: _inputDecorationTheme(),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
              titleMedium: TextStyle(
                  color: Color(0xFF2E2E2E), fontWeight: FontWeight.normal)),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const SplashScreen());
  }

  ElevatedButtonThemeData _elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 56)),
            backgroundColor: MaterialStateProperty.all(const Color(0xFF2782FD)),
            foregroundColor:
                MaterialStateProperty.all(const Color(0xFF2782FD))));
  }

  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 23),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: const Color(0xFF707070).withAlpha(25));
  }
}
