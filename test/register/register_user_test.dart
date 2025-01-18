import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:cpd_flutterapp/services/auth_service.dart';

class MockClient extends http.BaseClient {
  final Map<Uri, http.Response> _mockResponses = {};

  void addMockResponse(Uri url, http.Response response) {
    _mockResponses[url] = response;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = _mockResponses[request.url];
    if (response != null) {
      return http.StreamedResponse(
        Stream.fromIterable([response.body.codeUnits]),
        response.statusCode,
        headers: response.headers,
      );
    }
    throw Exception('Geen mock-response voor ${request.url}');
  }
}

void main() {
  group('AuthService - registerUser', () {
    late MockClient mockClient;
    late AuthService authService;

    setUp(() {
      mockClient = MockClient();
      authService = AuthService(client: mockClient);
    });

    test('Registers user successfully with valid data', () async {
      final url = Uri.parse('https://team-management-api.dops.tech/api/v2/auth/register');
      final mockResponse = http.Response('', 201); // Simuleer succesvolle registratie

      // Voeg de mock-response toe
      mockClient.addMockResponse(url, mockResponse);

      // Test de registratie
      final result = await authService.registerUser('LocalTest2025', 'Password2025!');

      // Controleer de uitkomst
      expect(result, isTrue, reason: 'De registratie zou moeten slagen met een geldige 201-response.');
    });

    test('Fails to register user with invalid data', () async {
      final url = Uri.parse('https://team-management-api.dops.tech/api/v2/auth/register');
      final mockResponse = http.Response('{"error": "Invalid data"}', 400); // Simuleer mislukte registratie

      // Voeg de mock-response toe
      mockClient.addMockResponse(url, mockResponse);

      // Test de registratie
      final result = await authService.registerUser('LocalTest2025', 'short');

      // Controleer de uitkomst
      expect(result, isFalse, reason: 'De registratie zou moeten falen met een foutieve 400-response.');
    });
  });
}
