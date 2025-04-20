import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const NominaApp());
}

class NominaApp extends StatelessWidget {
  const NominaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Nómina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF2F5FA),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
      ),
      home: const LoginScreen(), // <- usa la clase importada desde login.dart
    );
  }
}
