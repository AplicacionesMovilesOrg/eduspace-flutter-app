import 'dart:convert';
import 'dart:io';

import 'package:eduspace_flutter_app/core/constants/api_constants.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/reports/domain/resource_light.dart';
import 'package:http/http.dart' as http;

class ResourceService {
  final StorageService _storageService;

  ResourceService({required StorageService storageService})
    : _storageService = storageService;

  Future<List<ResourceLight>> getResourcesByClassroom(
    String classroomId,
  ) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getClassroomResourcesPath(classroomId)}',
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> list = jsonDecode(response.body) as List<dynamic>;
        return list
            .map((e) => ResourceLight.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Resources not found (404)');
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
      throw Exception('Unexpected error while fetching resources: $e');
    }
  }
}
