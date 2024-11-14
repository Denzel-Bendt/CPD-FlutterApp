import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart'; // Zorg dat AuthService wordt geïmporteerd
import 'dart:convert';
import 'teams_page.dart';
import 'users_page.dart';
import 'login_screen.dart';
import 'profile_page.dart'; // Import de ProfilePage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Logger logger = Logger();
  final AuthService authService = AuthService(); // Maak een instantie van AuthService
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamDescriptionController = TextEditingController();

  Future<void> _createTeam(BuildContext context) async {
    ApiService apiService = ApiService();

    String teamName = _teamNameController.text;
    String teamDescription = _teamDescriptionController.text;

    final response = await apiService.createTeam(teamName, teamDescription);

    logger.i('Response status: ${response.statusCode}');
    logger.i('Response body: ${response.body}');

    if (context.mounted) {
      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        var teamId = responseData['data']['id'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Team succesvol aangemaakt met ID: $teamId')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout bij het aanmaken van team: ${response.body}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TeamSync'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              } else if (value == 'Logout') {
                // Log de gebruiker uit
                authService.logout();

                // Navigeren naar het inlogscherm en alle eerdere schermen verwijderen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Profile', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welkom bij TeamSync!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _teamNameController,
              decoration: const InputDecoration(
                labelText: 'Voer Teamnaam in',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _teamDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Voer Teambeschrijving in',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _createTeam(context),
              child: const Text('Maak Team'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeamsPage()),
                );
              },
              child: const Text('Bekijk Teams'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersPage()),
                );
              },
              child: const Text('Bekijk Gebruikers'),
            ),
          ],
        ),
      ),
    );
  }
}
