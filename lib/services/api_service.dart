import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:cpd_flutterapp/services/auth_service.dart';

class ApiService {
  final String baseUrl = 'https://team-management-api.dops.tech/api/v2/';
  final Logger _logger = Logger();

  // Haal alle gebruikers op
  Future<http.Response> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}users'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (AuthService.authToken != null)
            'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      _logger.i('Gebruikersresponse: ${response.body}');
      if (response.statusCode == 200) {
        _logger.i('Gebruikers succesvol opgehaald: ${response.body}');
      } else {
        _logger.w('Fout bij het ophalen van gebruikers: ${response.body}');
      }
      return response;
    } catch (e) {
      _logger.e('Er is een fout opgetreden bij het ophalen van gebruikers: $e');
      rethrow;
    }
  }

  // Haal teamdetails op inclusief leden
  Future<Map<String, dynamic>?> getTeamDetails(int teamId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}teams/$teamId'),
        headers: {
          'Content-Type': 'application/json',
          if (AuthService.authToken != null)
            'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        _logger.i('Teamdetails succesvol opgehaald: ${response.body}');
        return json.decode(response.body)['data'];
      } else {
        _logger.w('Fout bij ophalen teamdetails: ${response.body}');
        return null;
      }
    } catch (e) {
      _logger.e('Fout bij het ophalen van teamdetails: $e');
      rethrow;
    }
  }

  // Voeg een gebruiker toe aan een team
Future<http.Response> addUserToTeam(int teamId, int userId) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}teams/$teamId/addUser'), // Zorgt voor correcte URI
      headers: {
        'Content-Type': 'application/json',
        if (AuthService.authToken != null)
          'Authorization': 'Bearer ${AuthService.authToken}', // Token toegevoegd
      },
      body: json.encode({'userId': userId}),
    );

    // Debug-informatie
    _logger.i('Request URL: ${Uri.parse('${baseUrl}teams/$teamId/addUser')}');
    _logger.i('Request Body: ${json.encode({'userId': userId})}');
    _logger.i('Response Status: ${response.statusCode}');
    _logger.i('Response Body: ${response.body}');

    return response;
  } catch (e) {
    _logger.e('Fout bij toevoegen gebruiker aan team: $e');
    rethrow;
  }
}




  // Maak een nieuw team
 // Maak een nieuw team
Future<http.Response> createTeam(String name, String description) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}teams'),
      headers: {
        'Content-Type': 'application/json',
        if (AuthService.authToken != null)
          'Authorization': 'Bearer ${AuthService.authToken}',
      },
      body: json.encode({
        'name': name,
        'description': description,
        'metadata': {'Icon': 'calendar_today'},
      }),
    );

    _logger.i('Team succesvol aangemaakt: ${response.body}');
    return response;
  } catch (e) {
    _logger.e('Fout bij aanmaken team: $e');
    rethrow;
  }
}


  // Haal alle teams op
  Future<http.Response> getTeams() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}teams'),
        headers: {
          'Content-Type': 'application/json',
          if (AuthService.authToken != null)
            'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );
      if (response.statusCode == 200) {
        _logger.i('Teams succesvol opgehaald: ${response.body}');
      } else {
        _logger.w('Fout bij ophalen teams: ${response.body}');
      }
      return response;
    } catch (e) {
      _logger.e('Fout bij ophalen teams: $e');
      rethrow;
    }
  }

  // Verwijder een team
  Future<http.Response> deleteTeam(int teamId) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}teams/$teamId'),
        headers: {
          'Accept': 'application/json',
          if (AuthService.authToken != null)
            'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );
      if (response.statusCode == 200) {
        _logger.i('Team succesvol verwijderd: $teamId');
      } else {
        _logger.w('Fout bij verwijderen team $teamId: ${response.body}');
      }
      return response;
    } catch (e) {
      _logger.e('Fout bij verwijderen team $teamId: $e');
      rethrow;
    }
  }
}
