import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key}); // Gebruik super.key in plaats van Key? key


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Management Applicatie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),  // Startpagina is nu LoginScreen
    );
  }
}