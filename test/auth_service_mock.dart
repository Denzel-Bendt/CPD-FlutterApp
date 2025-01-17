import 'package:cpd_flutterapp/services/auth_service.dart';

class MockAuthService extends AuthService {
  bool shouldLoginSucceed = true; // Toggle om aan te geven of login moet slagen

  @override
  Future<bool> loginUser(String name, String password) async {
    return shouldLoginSucceed;
  }

  @override
  Future<bool> registerUser(String name, String password) async {
    return shouldLoginSucceed;
  }
}
