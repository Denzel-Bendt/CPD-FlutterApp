// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // Verifieer het pad
import '../home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login/Registratie"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Gebruikersnaam'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Wachtwoord'),
                obscureText: true, // Verbergt de tekst die wordt ingevoerd
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool registered = await _authService.registerUser(
                    _usernameController.text,
                    _passwordController.text,
                  );
                  if (registered) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(teamId: 1), // Voeg een geldige teamId toe
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registratie mislukt')),
                    );
                  }
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool loggedIn = await _authService.loginUser(
                    _usernameController.text,
                    _passwordController.text,
                  );
                  if (loggedIn) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(teamId: 1), // Voeg een geldige teamId toe
                      ),
                    );
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Inloggen mislukt')),
                      );
                    }
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
