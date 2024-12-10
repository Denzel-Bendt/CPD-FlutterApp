import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'auth_service.dart';

class ApiService {
  final String baseUrl = 'https://team-management-api.dops.tech/api/v2/';
  final Logger _logger = Logger();

  // Methode om teamdetails op te halen
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
      _logger.e('Fout bij ophalen teamdetails: $e');
      rethrow;
    }
  }

  // Methode om een gebruiker toe te voegen aan een team
  Future<http.Response> addUserToTeam(int teamId, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}teams/$teamId/addUser'),
        headers: {
          'Content-Type': 'application/json',
          if (AuthService.authToken != null)
            'Authorization': 'Bearer ${AuthService.authToken}',
        },
        body: json.encode({'userId': userId}),
      );

      _logger.i('Gebruiker toegevoegd aan team: ${response.body}');
      return response;
    } catch (e) {
      _logger.e('Fout bij toevoegen gebruiker aan team: $e');
      rethrow;
    }
  }

  // Methode om een gebruiker te verwijderen uit een team
  Future<http.Response> removeUserFromTeam(int teamId, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}teams/$teamId/removeUser'),
        headers: {
          'Content-Type': 'application/json',
          if (AuthService.authToken != null)
            'Authorization': 'Bearer ${AuthService.authToken}',
        },
        body: json.encode({'userId': userId}),
      );

      _logger.i('Gebruiker verwijderd uit team: ${response.body}');
      return response;
    } catch (e) {
      _logger.e('Fout bij verwijderen gebruiker: $e');
      rethrow;
    }
  }

  // Methode om een nieuw team aan te maken
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
        }),
      );

      _logger.i('Team succesvol aangemaakt: ${response.body}');
      return response;
    } catch (e) {
      _logger.e('Fout bij aanmaken team: $e');
      rethrow;
    }
  }

  // Methode om alle teams op te halen
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

// Methode om een gebruiker admin te maken
Future<http.Response> makeUserAdmin(int userId) async {
  try {
    final response = await http.post(
      Uri.parse('${baseUrl}users/$userId/makeAdmin'),
      headers: {
        'Content-Type': 'application/json',
        if (AuthService.authToken != null)
          'Authorization': 'Bearer ${AuthService.authToken}',
      },
    );

    _logger.i('Gebruiker admin gemaakt: ${response.body}');
    return response;
  } catch (e) {
    _logger.e('Fout bij het toekennen van admin-rechten: $e');
    rethrow;
  }
}

  // Methode om alle gebruikers op te halen
  Future<http.Response> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}users'),
        headers: {
          'Content-Type': 'application/json',
          if (AuthService.authToken != null)
            'Authorization': 'Bearer ${AuthService.authToken}',
        },
      );

      if (response.statusCode == 200) {
        _logger.i('Gebruikers succesvol opgehaald: ${response.body}');
      } else {
        _logger.w('Fout bij ophalen gebruikers: ${response.body}');
      }
      return response;
    } catch (e) {
      _logger.e('Fout bij ophalen gebruikers: $e');
      rethrow;
    }
  }
}
