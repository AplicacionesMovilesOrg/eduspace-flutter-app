import 'dart:convert';
import 'dart:io';
import 'package:eduspace_flutter_app/core/constants/api_constants.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/shared_area.dart';
import 'package:http/http.dart' as http;

class SharedAreaService {
  Future<List<SharedArea>> getAllSharedAreas() async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.sharedAreasEndpoint
      );
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => SharedArea.fromJson(json)).toList();
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Shared areas endpoint not found (404)');
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
      throw Exception('Unexpected error while fetching shared areas: $e');
    }
  }

  Future<SharedArea> getSharedAreaById(String id) async {
    try {
      final Uri uri = Uri.parse(
        ApiConstants.baseUrl + ApiConstants.getSharedAreaByIdPath(id)
      );
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == HttpStatus.ok) {
        return SharedArea.fromJson(jsonDecode(response.body));
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Shared area not found (404)');
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
      throw Exception('Unexpected error while fetching shared area: $e');
    }
  }
}