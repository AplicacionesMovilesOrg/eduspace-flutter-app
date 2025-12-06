import 'dart:convert';
import 'dart:io';

import 'package:eduspace_flutter_app/core/constants/api_constants.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/reports/domain/report.dart';
import 'package:eduspace_flutter_app/features/reports/domain/report_with_context.dart';
import 'package:http/http.dart' as http;

class ReportService {
  final StorageService _storageService;

  ReportService({required StorageService storageService})
    : _storageService = storageService;

  Future<List<Report>> getReportsByResource(String resourceId) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getReportsByResourcePath(resourceId)}',
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
            .map((e) => Report.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Reports not found (404)');
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
      throw Exception('Unexpected error while fetching reports: $e');
    }
  }

  Future<Report> createReport({
    required String kindOfReport,
    required String description,
    required String resourceId,
  }) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.createReportEndpoint}',
      );

      final body = jsonEncode({
        'kindOfReport': kindOfReport,
        'description': description,
        'resourceId': resourceId,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      });

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == HttpStatus.created) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        return Report.fromJson(json);
      }

      if (response.statusCode >= 500) {
        throw HttpException('Server error ${response.statusCode}');
      }

      throw HttpException(
        'Error creating report: ${response.statusCode} - ${response.body}',
      );
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Unexpected error while creating report: $e');
    }
  }

  Future<List<ReportWithContext>> getReportsByTeacher(String teacherId) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getTeacherReportsPath(teacherId)}',
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
            .map((e) => ReportWithContext.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Teacher reports not found (404)');
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
      throw Exception('Unexpected error while fetching teacher reports: $e');
    }
  }

  Future<Report> updateReport({
    required String reportId,
    required String kindOfReport,
    required String description,
  }) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.updateReportPath(reportId)}',
      );

      final body = jsonEncode({
        'kindOfReport': kindOfReport,
        'description': description,
      });

      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == HttpStatus.ok) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        return Report.fromJson(json);
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Report not found (404)');
      }

      if (response.statusCode >= 500) {
        throw HttpException('Server error ${response.statusCode}');
      }

      throw HttpException(
        'Error updating report: ${response.statusCode} - ${response.body}',
      );
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Unexpected error while updating report: $e');
    }
  }

  Future<void> deleteReport(String reportId) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.deleteReportPath(reportId)}',
      );

      final response = await http.delete(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == HttpStatus.noContent ||
          response.statusCode == HttpStatus.ok) {
        return;
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Report not found (404)');
      }

      if (response.statusCode >= 500) {
        throw HttpException('Server error ${response.statusCode}');
      }

      throw HttpException(
        'Error deleting report: ${response.statusCode} - ${response.body}',
      );
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } catch (e) {
      throw Exception('Unexpected error while deleting report: $e');
    }
  }
}
