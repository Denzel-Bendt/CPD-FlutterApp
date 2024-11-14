import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class AuthService {
  final String baseUrl = 'https://team-management-api.dops.tech/api/v2/auth';
  final Logger _logger = Logger();

  Future<bool> registerUser(String name, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/register'),
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

  Future<bool> loginUser(String name, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/login'),
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
}
