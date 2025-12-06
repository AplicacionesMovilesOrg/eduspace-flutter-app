import 'dart:convert';
import 'dart:io';
import 'package:eduspace_flutter_app/core/constants/api_constants.dart';
import 'package:eduspace_flutter_app/core/services/storage_service.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/reservation.dart';
import 'package:http/http.dart' as http;

class ReservationService {
  final StorageService _storageService;

  ReservationService({required StorageService storageService})
    : _storageService = storageService;

  Future<Reservation> createReservation({
    required String teacherId,
    required String areaId,
    required Reservation reservation,
  }) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final Uri uri = Uri.parse(
        ApiConstants.baseUrl +
            ApiConstants.createReservationPath(teacherId, areaId),
      );

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(reservation.toJson(forPost: true)),
      );

      if (response.statusCode == HttpStatus.created ||
          response.statusCode == HttpStatus.ok) {
        return Reservation.fromJson(jsonDecode(response.body));
      }

      if (response.statusCode == HttpStatus.badRequest) {
        throw HttpException('Invalid reservation data (400): ${response.body}');
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException(
          'Teacher or area not found (404): ${response.body}',
        );
      }

      if (response.statusCode >= 500) {
        throw HttpException(
          'Server error ${response.statusCode}: ${response.body}',
        );
      }

      throw HttpException(
        'Unexpected HTTP Status: ${response.statusCode}: ${response.body}',
      );
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Unexpected error while creating reservation: $e');
    }
  }

  Future<List<Reservation>> getTeacherReservations({
    required String teacherId,
  }) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final Uri uri = Uri.parse(
        ApiConstants.baseUrl +
            ApiConstants.getTeacherReservationsPath(teacherId),
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
        return jsonList.map((json) => Reservation.fromJson(json)).toList();
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Teacher not found (404): ${response.body}');
      }

      if (response.statusCode >= 500) {
        throw HttpException(
          'Server error ${response.statusCode}: ${response.body}',
        );
      }

      throw HttpException(
        'Unexpected HTTP Status: ${response.statusCode}: ${response.body}',
      );
    } on SocketException {
      throw const SocketException('Failed to establish network connection');
    } on FormatException catch (e) {
      throw FormatException('Failed to parse response: $e');
    } catch (e) {
      throw Exception('Unexpected error while fetching reservations: $e');
    }
  }
}
