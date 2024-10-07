import 'package:flutter/material.dart';
import 'services/api_service.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
  onPressed: () async {
    ApiService apiService = ApiService();
    Map<String, dynamic> teamData = {
      'name': 'Nieuw Team', // Voeg hier andere gegevens toe
    };

    final response = await apiService.createTeam(teamData);

    // Controleer of de widget nog steeds gemonteerd is
    if (context.mounted) {
      if (response.statusCode == 201) {
        // Team succesvol aangemaakt
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Team succesvol aangemaakt!')),
        );
      } else {
        // Foutafhandeling
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Er is een fout opgetreden.')),
        );
      }
    }
  },
  child: const Text('Begin met plannen'),
),
          ],
        ),
      ),
    );
  }
}
