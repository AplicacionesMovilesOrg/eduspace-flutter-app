import 'dart:convert';
import 'dart:io';
import 'package:eduspace_flutter_app/core/constants/api_constants.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/classroom/domain/models/classroom.dart';
import 'package:http/http.dart' as http;

class ClassroomService {
  final StorageService _storageService;

  ClassroomService({required StorageService storageService})
    : _storageService = storageService;

  Future<List<Classroom>> getByTeacherId(String teacherId) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final Uri uri = Uri.parse(
        '${ApiConstants.baseUrl}/classrooms/teachers/$teacherId',
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Classroom.fromJson(json)).toList();
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Classrooms not found (404)');
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
      throw Exception('Unexpected error while fetching classrooms: $e');
    }
  }
}
