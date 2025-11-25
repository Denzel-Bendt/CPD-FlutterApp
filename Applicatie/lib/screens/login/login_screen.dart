import 'package:flutter/material.dart';
import 'package:cpd_flutterapp/services/auth_service.dart';
import 'package:cpd_flutterapp/screens/home/home_page.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late final AuthService _authService;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    final http.Client client = http.Client();
    _authService = AuthService(client: client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Welkom bij Teamsync',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 120),
              const Text(
                'Gebruikersnaam',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 480,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 240, 240, 240),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF336791), width: 2.0),
                        borderRadius: BorderRadius.circular(31.0)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Wachtwoord',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 480,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 240, 240, 240),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(31.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF336791), width: 2.0),
                        borderRadius: BorderRadius.circular(31.0)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                width: 480,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Linkerkant: "Herinner mij" met checkbox
                    Row(
                      children: [
                        Theme(
                          data: ThemeData(
                            checkboxTheme: CheckboxThemeData(
                              fillColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return const Color(
                                        0xFF336791); // ← Geselecteerde kleur
                                  }
                                },
                              ),
                            ),
                          ),
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (bool? value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                        ),
                        const Text(
                          'Herinner mij',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 2, 3, 4),
                          ),
                        ),
                      ],
                    ),

                    // Rechterkant: Login knop
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
                              builder: (context) => const HomePage(teamId: 1),
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
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(260, 50),
                        backgroundColor: const Color(0xFF336791),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}