import 'package:flutter/material.dart';
import '../../services/api_service.dart'as api_service;
import 'team_details_page.dart'; // Voor het bekijken van teamdetails
import 'dart:convert';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final api_service.ApiService apiService = api_service.ApiService();
  List<dynamic> teams = [];

  @override
  void initState() {
    super.initState();
    _fetchTeams();
  }

 Future<void> _fetchTeams() async {
  try {
    final response = await apiService.getTeams();
    if (!mounted) return; // Controleer of de widget nog "mounted" is

    if (response.statusCode == 200) {
      setState(() {
        teams = List<dynamic>.from(json.decode(response.body)['data']);
      });
    } else {
      _showError('Fout bij ophalen teams: ${response.body}');
    }
  } catch (e) {
    if (mounted) { // Controleer opnieuw of de widget nog bestaat
      _showError('Er is een fout opgetreden: $e');
    }
  }
}

void _showError(String message) {
  if (mounted) { // Voeg hier ook een check toe
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
      ),
      body: teams.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return ListTile(
                  title: Text(team['name']),
                  subtitle: Text(team['description'] ?? 'Geen beschrijving'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeamDetailsPage(teamId: team['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
