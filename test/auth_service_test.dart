import 'package:flutter_test/flutter_test.dart';
import 'auth_service_mock.dart';
 // Importeer de handmatige mock


void main() {
  group('AuthService Tests', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    test('Login succeeds', () async {
      mockAuthService.shouldLoginSucceed = true;

      final result = await mockAuthService.loginUser('testUser', 'testPassword');

      expect(result, isTrue); // Login moet slagen
    });

    test('Login fails', () async {
      mockAuthService.shouldLoginSucceed = false;

      final result = await mockAuthService.loginUser('testUser', 'testPassword');

      expect(result, isFalse); // Login moet mislukken
    });

    test('Registration succeeds', () async {
      mockAuthService.shouldLoginSucceed = true;

      final result =
          await mockAuthService.registerUser('testUser', 'testPassword');

      expect(result, isTrue); // Registratie moet slagen
    });

    test('Registration fails', () async {
      mockAuthService.shouldLoginSucceed = false;

      final result =
          await mockAuthService.registerUser('testUser', 'testPassword');

      expect(result, isFalse); // Registratie moet mislukken
    });
  });
}
