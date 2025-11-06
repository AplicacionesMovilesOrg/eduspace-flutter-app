import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:eduspace_flutter_app/core/constants/api_constants.dart';
import 'package:eduspace_flutter_app/features/auth/domain/user.dart';

class AuthService {
  Future<User> login(String username, String password) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.signInEndpoint}');

      final http.Response response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        return User(
          id: json['id'],
          email: json['email'],
          token: json['token'],
        );
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
