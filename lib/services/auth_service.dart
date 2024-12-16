import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class AuthService {
  final String baseUrl = 'https://team-management-api.dops.tech/api/v2';
  final Logger _logger = Logger();
  static String? authToken; // Token wordt hier opgeslagen

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
        var responseData = json.decode(response.body);
        authToken = responseData['data']['token'];
        _logger.i('Token opgeslagen: $authToken'); // Debug token
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

  // Methode om uit te loggen
  void logout() {
    authToken = null; // Token wordt verwijderd
    _logger.i('Gebruiker is uitgelogd');
  }

  // Controleer of een token geldig is
  bool isTokenValid() {
    if (authToken == null) return false;
    try {
      final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(authToken!.split('.')[1]))));
      final expiry = payload['exp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      return expiry > now;
    } catch (e) {
      _logger.e('Token validatie mislukt: $e');
      return false;
    }
  }
}
