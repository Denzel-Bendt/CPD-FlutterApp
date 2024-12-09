import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../services/api_service.dart' as service;
import '../services/auth_service.dart';
import 'teams/teams_page.dart';
import 'users_page.dart';
import 'login/login_screen.dart';
import 'profile_page.dart';
import 'teams/team_details_page.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  final int teamId; // Team ID toegevoegd

  const HomePage({super.key, required this.teamId});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Logger logger = Logger();
  final AuthService authService = AuthService();
  final service.ApiService apiService = service.ApiService();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamDescriptionController = TextEditingController();

  Future<void> _createTeam(BuildContext context) async {
    String teamName = _teamNameController.text;
    String teamDescription = _teamDescriptionController.text;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response = await apiService.createTeam(teamName, teamDescription);
      logger.i('Response status: ${response.statusCode}');
      logger.i('Response body: ${response.body}');

      if (response.statusCode == 201) {
        var responseData = json.decode(response.body);
        var teamId = responseData['data']['id'];

        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Team succesvol aangemaakt met ID: $teamId')),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('Fout bij het aanmaken van team: ${response.body}')),
        );
      }
    } catch (e) {
      logger.e('Er is een fout opgetreden bij het aanmaken van het team: $e');
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Er is een fout opgetreden. Probeer het opnieuw.')),
      );
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
                authService.logout();
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
                  MaterialPageRoute(
                    builder: (context) => UsersPage(teamId: widget.teamId), // Correct teamId meegegeven
                  ),
                );
              },
              child: const Text('Gebruikers Toevoegen via Lijst'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeamDetailsPage(teamId: widget.teamId),
                  ),
                );
              },
              child: const Text('Open Team Details'),
            ),
          ],
        ),
      ),
    );
  }
}
