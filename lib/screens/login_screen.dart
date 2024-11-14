// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'services/auth_service.dart'; // Verifieer het pad
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // Using super.key instead of Key? key

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
        title: Text("Login/Registratie"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Gebruikersnaam'),
              ),
              TextField(
  controller: _passwordController,
  decoration: InputDecoration(
    labelText: 'Wachtwoord'
  ),
  obscureText: true,  // Verbergt de tekst die wordt ingevoerd

              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool registered = await _authService.registerUser(_usernameController.text, _passwordController.text);
                  if (registered) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Registratie mislukt'))
                    );
                  }
                },
                child: Text('Register'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool loggedIn = await _authService.loginUser(_usernameController.text, _passwordController.text);
                  if (loggedIn) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Inloggen mislukt'))
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
