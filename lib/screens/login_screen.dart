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
      backgroundColor: Colors.white70,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(60.0), // Set the height of the AppBar
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0), // Border color
              width: 4.0, // Border thickness
            ),
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10)), // Optional: Rounded corners
          ),
          child: AppBar(
            backgroundColor: Colors.grey, // Set background color of AppBar
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Flutter App"),
              ],
            ),
            elevation: 0, // Remove shadow
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: const Text(
                  'Login Pagina', // Your H1 text
                  style: TextStyle(
                    fontSize: 36, // H1 font size
                    fontWeight: FontWeight.w300, // Bold text
                    color: Colors.black, // Text color
                  ),
                  textAlign: TextAlign.center, // Center the text
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Gebruikersnaam',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Rounded corners
                      borderSide: BorderSide(
                        color: Colors.black, // Border color
                        width: 1.0, // Border thickness
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      borderSide: BorderSide(
                        color: Colors.black, // Border color when focused
                        width: 1.0, // Border thickness when focused
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70), // Margin of 35 pixels between fields
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Wachtwoord',
                    // Here you define the border for the TextField
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20.0), // Rounded corners
                      borderSide: BorderSide(
                        color: Colors.black, // Border color
                        width: 1.0, // Border thickness
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded corners
                      borderSide: BorderSide(
                        color: Colors.black, // Border color when focused
                        width: 1.0, // Border thickness when focused
                      ),
                    ),
                    // obscureText: true,// dit geeft een error // Verbergt de tekst die wordt ingevoerd
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool registered = await _authService.registerUser(
                      _usernameController.text, _passwordController.text);
                  if (registered) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registratie mislukt')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      const Color.fromARGB(255, 143, 147, 150), // Text color
                ),
                child: const Text('Register'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool loggedIn = await _authService.loginUser(
                      _usernameController.text, _passwordController.text);
                  if (loggedIn) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Inloggen mislukt')));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      const Color.fromARGB(255, 143, 147, 150), // Text color
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
