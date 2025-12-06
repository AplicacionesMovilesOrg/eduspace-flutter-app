import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:eduspace_flutter_app/core/constants/api_constants.dart';
import 'package:eduspace_flutter_app/features/auth/domain/user.dart';

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  Future<User> login(String username, String password) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.signInEndpoint}',
      );

      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 401) {
        throw Exception('Invalid username or password');
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to login: ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final user = User.fromJson(json);

      if (user.role != 'RoleTeacher') {
        throw Exception('Only teachers can access this application');
      }

      return user;
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Login failed: $e');
    }
  }
}
