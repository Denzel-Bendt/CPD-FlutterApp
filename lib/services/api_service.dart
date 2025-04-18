import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'auth_service.dart';

class ApiService {
  final String baseUrl = 'https://team-management-api.weensum.nl/api/v2/auth/login';
  final Logger _logger = Logger();

  // Methode om headers op te bouwen
  Map<String, String> _buildHeaders() {
    return {
      'Content-Type': 'application/json',
      if (AuthService.authToken != null)
        'Authorization': 'Bearer ${AuthService.authToken}',
    };
  }

  // Methode om teamdetails op te halen
  Future<Map<String, dynamic>?> getTeamDetails(int teamId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}teams/$teamId'),
        headers: _buildHeaders(),
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
        headers: _buildHeaders(),
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
        headers: _buildHeaders(),
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
        headers: _buildHeaders(),
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
        headers: _buildHeaders(),
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

  // Methode om teamafspraken op te halen
  Future<http.Response> getTeamEvents(int teamId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}teams/$teamId/events'),
        headers: _buildHeaders(),
      );

      _logger.i('Team evenementen succesvol opgehaald: ${response.body}');
      return response;
    } catch (e) {
      _logger.e('Fout bij ophalen team evenementen: $e');
      rethrow;
    }
  }

  // Methode om gebruikersafspraken op te halen
  Future<http.Response> getUserEvents() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}users/events'),
        headers: _buildHeaders(),
      );

      _logger.i('Gebruikersafspraken succesvol opgehaald: ${response.body}');
      return response;
    } catch (e) {
      _logger.e('Fout bij ophalen gebruikersafspraken: $e');
      rethrow;
    }
  }

  // Methode om een gebruiker admin te maken
  Future<http.Response> makeUserAdmin(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}users/$userId/makeAdmin'),
        headers: _buildHeaders(),
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
        headers: _buildHeaders(),
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

  // Methode om een evenement te creëren
  Future<http.Response> createEvent({
    required String title,
    required String description,
    required String datetimeStart,
    required String datetimeEnd,
    required int teamId,
    required Map<String, dynamic> location,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}events'),
        headers: _buildHeaders(),
        body: jsonEncode({
          'title': title,
          'description': description,
          'datetimeStart': datetimeStart,
          'datetimeEnd': datetimeEnd,
          'teamId': teamId,
          'location': location,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Fout bij aanmaken evenement: $e');
    }
  }

  // Methode om een evenement bij te werken
  Future<http.Response> updateEvent({
    required int id,
    required String title,
    required String description,
    required String datetimeStart,
    required String datetimeEnd,
    required Map<String, dynamic> location,
  }) async {
    return await http.put(
      Uri.parse('${baseUrl}events/$id'),
      headers: _buildHeaders(),
      body: jsonEncode({
        'title': title,
        'description': description,
        'datetimeStart': datetimeStart,
        'datetimeEnd': datetimeEnd,
        'location': location,
      }),
    );
  }

  // Methode om een evenement te verwijderen
  Future<http.Response> deleteEvent(int id) async {
    return await http.delete(
      Uri.parse('${baseUrl}events/$id'),
      headers: _buildHeaders(),
    );
  }

  // Methode om gecombineerde evenementen (individueel en team) op te halen
Future<List<Map<String, dynamic>>> getCombinedEvents(int teamId) async {
  try {
    List<Map<String, dynamic>> userEvents = [];
    List<Map<String, dynamic>> teamEvents = [];

    // Haal user events op
    try {
      final userEventsResponse = await getUserEvents();
      _logger.i('User Events Respons: ${userEventsResponse.body}');

      if (userEventsResponse.statusCode == 200) {
        userEvents = (json.decode(userEventsResponse.body)['data'] as List)
            .cast<Map<String, dynamic>>();
      } else {
        _logger.w('Fout bij ophalen user events: ${userEventsResponse.body}');
      }
    } catch (e) {
      _logger.e('Fout bij ophalen user events: $e');
    }

    // Haal team events op
    try {
      final teamEventsResponse = await getTeamEvents(teamId);
      _logger.i('Team Events Respons: ${teamEventsResponse.body}');

      if (teamEventsResponse.statusCode == 200) {
        teamEvents = (json.decode(teamEventsResponse.body)['data'] as List)
            .cast<Map<String, dynamic>>();
      } else {
        _logger.w('Fout bij ophalen team events: ${teamEventsResponse.body}');
      }
    } catch (e) {
      _logger.e('Fout bij ophalen team events: $e');
    }

    // Combineer de events en retourneer
    return [...userEvents, ...teamEvents];
  } catch (e) {
    _logger.e('Fout bij combineren van evenementen: $e');
    rethrow;
  }
}


  // Methode om alle evenementen op te halen
  Future<http.Response> getAllEvents() async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}events'),
        headers: _buildHeaders(),
      );

      _logger.i('Evenementen opgehaald: ${response.body}');
      return response;
    } catch (e) {
      _logger.e('Fout bij ophalen evenementen: $e');
      rethrow;
    }
  }

  // Methode om gebruikersprofiel op te halen
Future<Map<String, dynamic>?> getUserProfile() async {
  try {
    final response = await http.get(
      Uri.parse('${baseUrl}users/me'),
      headers: _buildHeaders(),
    );

    if (response.statusCode == 200) {
      _logger.i('Gebruikersprofiel: ${response.body}');
      return json.decode(response.body)['data'];
    } else {
      _logger.w('Fout bij ophalen gebruikersprofiel: ${response.body}');
      return null;
    }
  } catch (e) {
    _logger.e('Fout bij ophalen gebruikersprofiel: $e');
    rethrow;
  }
}


}
