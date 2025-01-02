import 'package:cpd_flutterapp/screens/teams/teams_page.dart';
import 'package:flutter/material.dart';

class TeamsStartPage extends StatefulWidget {
  const TeamsStartPage({super.key});

  int? get teamId => null;

  @override
  State<TeamsStartPage> createState() => _TeamsStartPageState();
}

class _TeamsStartPageState extends State<TeamsStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Flutter!',
              style: TextStyle(fontSize: 20),
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
                    builder: (context) => const TeamAddPage(teamId: null),
                  ),
                );
              },
              child: const Text('Maak een team aan'),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamAddPage extends StatefulWidget {
  const TeamAddPage({required this.teamId, super.key});
  final int? teamId; // Made nullable

  @override
  State<TeamAddPage> createState() => _TeamAddPageState();
}

class _TeamAddPageState extends State<TeamAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Team'),
      ),
      body: Center(
        child: Text('Team ID: ${widget.teamId ?? 'No ID provided'}'),
      ),
    );
  }
}
