import 'dart:convert';
import 'dart:io';
import 'package:eduspace_flutter_app/core/constants/api_constants.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/classroom/domain/models/teacher_profile.dart';
import 'package:http/http.dart' as http;

class TeacherProfileService {
  final StorageService _storageService;

  TeacherProfileService({required StorageService storageService})
    : _storageService = storageService;

  Future<TeacherProfile> getByAccountId(String accountId) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/teachers-profiles/account/$accountId',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return TeacherProfile.fromJson(jsonDecode(response.body));
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Teacher profile not found (404)');
      }

      if (response.statusCode >= 500) {
        throw HttpException('Server error ${response.statusCode}');
      }

      throw HttpException('Unexpected HTTP Status: ${response.statusCode}');
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Unexpected error while fetching teacher profile: $e');
    }
  }
}
