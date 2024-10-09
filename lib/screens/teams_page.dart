import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'services/api_service.dart';

class TeamsPage extends StatelessWidget {
  const TeamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alle Teams'),
      ),
      body: FutureBuilder<List<Team>>(
        future: fetchTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Fout: ${snapshot.error}'));
          } else {
            final teams = snapshot.data!;
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return ListTile(
                  title: Text(team.name),
                  subtitle: Text(team.description ?? 'Geen beschrijving'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      // Vraag bevestiging voordat je het team verwijdert
                      bool confirm = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Weet je het zeker?'),
                            content: const Text('Je kunt dit team niet ongedaan maken.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Annuleren'),
                                onPressed: () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: const Text('Verwijderen'),
                                onPressed: () => Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm) {
                        final apiService = ApiService();
                        final response = await apiService.deleteTeam(team.id); // Geen .toString() meer


                        // Controleer of de widget nog steeds gemonteerd is
                        if (!context.mounted) return;

                        if (response.statusCode == 200) {
                          // Succesvol verwijderd
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Team succesvol verwijderd!')),
                          );
                          // Vernieuw de lijst van teams
                          (context as Element).markNeedsBuild();
                        } else {
                          // Fout bij verwijderen
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Fout bij het verwijderen van het team: ${response.body}')),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Team>> fetchTeams() async {
    final response = await http.get(
      Uri.parse('https://team-management-api.dops.tech/api/v1/teams'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final teams = (data['data'] as List).map((teamJson) => Team.fromJson(teamJson)).toList();
      return teams;
    } else {
      throw Exception('Fout bij het ophalen van teams');
    }
  }
}

class Team {
  final int id;
  final String name;
  final String? description;

  Team({required this.id, required this.name, this.description});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
