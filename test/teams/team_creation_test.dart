import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'mock_client.dart';

void main() {
  group('ApiService - createTeam', () {
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
    });

    test('Successfully creates a team', () async {
      // Mock API-url en response
      final url = Uri.parse('https://team-management-api.dops.tech/api/v2/teams');
      final mockResponse = http.Response('{"message": "Team aangemaakt"}', 201);

      // Voeg de mock-response toe
      mockClient.addMockResponse(url, mockResponse);

      // Simuleer een POST-aanroep
      final response = await mockClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: '{"name": "Team Naam", "description": "Team Beschrijving"}',
      );

      // Controleer de response
      expect(response.statusCode, 201, reason: 'De API zou een 201-statuscode moeten retourneren.');
      expect(response.body, '{"message": "Team aangemaakt"}');
    });
  });
}
