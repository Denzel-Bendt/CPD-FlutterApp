import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://team-management-api.dops.tech/api/v1/';

  // Methode om een nieuw team aan te maken
  Future<http.Response> createTeam(String name, String description) async {
    Map<String, dynamic> teamData = {
      'name': name,
      'description': description,
      'metadata': {
        'Icon': 'calendar_today', // Metadata met een icon
      },
    };

    final response = await http.post(
      Uri.parse('${baseUrl}teams'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Voeg accept header toe
      },
      body: json.encode(teamData),
    );
    return response;
  }

  // Methode om teams op te halen
  Future<http.Response> getTeams() async {
    final response = await http.get(
      Uri.parse('${baseUrl}teams'),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  // Methode om een team te verwijderen
  Future<http.Response> deleteTeam(String teamId) async {
    final response = await http.delete(
      Uri.parse('${baseUrl}teams/$teamId'),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }
}
