import 'package:flutter/material.dart';
import 'services/api_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _createTeam(BuildContext context) async {
    ApiService apiService = ApiService();

    // Stel je teamnaam en beschrijving in
    String teamName = 'Team Alpha'; // Of gebruik je studentnummer
    String teamDescription = 'Dit is een team';

    final response = await apiService.createTeam(teamName, teamDescription);

    if (context.mounted) {
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Team succesvol aangemaakt!')),
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
