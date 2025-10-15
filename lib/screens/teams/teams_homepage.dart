// teams_homepage.dart
import 'package:flutter/material.dart';
import '../teams/teams_page.dart'; // Voor Bekijk Teams
import '../users/users_page.dart'; // Voor Bekijk Gebruikers

class TeamsHomePage extends StatefulWidget {
  const TeamsHomePage({super.key});

  @override
  State<TeamsHomePage> createState() => _TeamsHomePageState();
}

class _TeamsHomePageState extends State<TeamsHomePage> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _teamDescriptionController =
      TextEditingController();

  // Voorbeeld functie voor het maken van een team - pas aan naar je eigen logica
  Future<void> _createTeam(BuildContext context) async {
    final String teamName = _teamNameController.text;
    final String teamDescription = _teamDescriptionController.text;

    if (teamName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voer een teamnaam in')),
      );
      return;
    }

    // Hier zou je je API call toevoegen om het team aan te maken
    try {
      // Voorbeeld: await apiService.createTeam(teamName, teamDescription);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Team "$teamName" succesvol aangemaakt!')),
      );

      // Reset de text fields
      _teamNameController.clear();
      _teamDescriptionController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fout bij aanmaken team: $e')),
      );
    }
  }

  void _showCreateTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nieuw Team Aanmaken'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _teamNameController,
                  decoration: const InputDecoration(
                    labelText: 'Teamnaam',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _teamDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Team beschrijving (optioneel)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _teamNameController.clear();
                _teamDescriptionController.clear();
              },
              child: const Text('Annuleren'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _createTeam(context);
              },
              child: const Text('Aanmaken'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams Beheer'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welkom tekst
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.groups,
                      size: 64,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Teams Beheer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Beheer je teams, bekijk teamleden en maak nieuwe teams aan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Knop: Maak Team
            ElevatedButton.icon(
              onPressed: () => _showCreateTeamDialog(context),
              icon: const Icon(Icons.add_circle_outline),
              label: const Text(
                'Maak Team',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            // Knop: Bekijk Teams
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeamsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.list_alt),
              label: const Text(
                'Bekijk Teams',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            // Knop: Bekijk Gebruikers
            ElevatedButton.icon(
              onPressed: () {
                // Je kunt een specifiek teamId meegeven of een andere approach gebruiken
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersPage(
                        teamId: 0), // Pas teamId aan naar je behoeften
                  ),
                );
              },
              icon: const Icon(Icons.people_outline),
              label: const Text(
                'Bekijk Gebruikers',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 32),

            // Snelle acties sectie
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Snelle Acties',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Maak een nieuw team aan\n• Bekijk alle teams\n• Beheer teamleden',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _teamDescriptionController.dispose();
    super.dispose();
  }
}
