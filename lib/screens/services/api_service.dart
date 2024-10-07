import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://team-management-api.dops.tech/api/v1/';

  // Methode om een nieuw team aan te maken
  Future<http.Response> createTeam(Map<String, dynamic> teamData) async {
    final response = await http.post(
      Uri.parse('${baseUrl}teams'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(teamData),
    );
    return response;
  }

  // Methode om teams op te halen (optioneel)
  Future<http.Response> getTeams() async {
    final response = await http.get(
      Uri.parse('${baseUrl}teams'),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }
}
