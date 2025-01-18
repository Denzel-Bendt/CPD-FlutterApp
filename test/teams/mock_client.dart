import 'package:http/http.dart' as http;

/// Mock HTTP-client om API-aanroepen te simuleren.
class MockClient extends http.BaseClient {
  final Map<Uri, http.Response> _mockResponses = {};

  /// Voeg een mock-response toe voor een specifieke URL.
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
