import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class AuthService {
  final String baseUrl = 'https://team-management-api.dops.tech/api/v2';
  final Logger _logger = Logger();

  // Methode om een nieuwe gebruiker te registreren
  Future<bool> registerUser(String name, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'password': password}),
      );

      if (response.statusCode == 201) {
        _logger.i('Registratie succesvol voor gebruiker: $name');
        return true;
      } else {
        _logger.e('Registratie mislukt: ${response.body}');
        return false;
      }
    } catch (e) {
      _logger.e('Failed to register user: $e');
      return false;
    }
  }

  // Methode om een gebruiker in te loggen
  Future<bool> loginUser(String name, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'password': password}),
      );

      if (response.statusCode == 200) {
        _logger.i('Inloggen succesvol voor gebruiker: $name');
        return true;
      } else {
        _logger.w('Inloggen mislukt: ${response.body}');
        return false;
      }
    } catch (e) {
      _logger.e('Failed to login user: $e');
      return false;
    }
  }

  // Methode om alle gebruikers op te halen
  Future<void> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'), // Zorg dat /users het juiste endpoint is
        headers: {
          'Content-Type': 'application/json',
          // Voeg 'Authorization': 'Bearer <je-token>' toe als authenticatie vereist is
        },
      );

      if (response.statusCode == 200) {
        var users = json.decode(response.body)['data'];
        _logger.i('Gebruikers succesvol opgehaald: $users');
      } else {
        _logger.e('Fout bij het ophalen van gebruikers: ${response.body}');
      }
    } catch (e) {
      _logger.e('Er is een fout opgetreden: $e');
    }
  }
}
