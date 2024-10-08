import 'package:flutter/material.dart';
import 'package:logger/logger.dart'; // Zorg ervoor dat deze import er is
import 'services/api_service.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final Logger logger = Logger(); // Maak een Logger instantie aan
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamDescriptionController = TextEditingController();

  Future<void> _createTeam(BuildContext context) async {
    ApiService apiService = ApiService();

    String teamName = _teamNameController.text;
    String teamDescription = _teamDescriptionController.text;

    final response = await apiService.createTeam(teamName, teamDescription);

    // Gebruik de logger in plaats van print
    logger.i('Response status: ${response.statusCode}'); // Informatie loggen
    logger.i('Response body: ${response.body}'); // Informatie loggen

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
          ],
        ),
      ),
    );
  }
}
