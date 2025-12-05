import 'dart:convert';
import 'dart:io';
import 'package:eduspace_flutter_app/core/constants/api_constants.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/Reservation.dart';
import 'package:http/http.dart' as http;

class ReservationService {
  Future<Reservation> createReservation({
    required String teacherId,
    required String areaId,
    required Reservation reservation,
  }) async {
    try {
      final Uri uri = Uri.parse(ApiConstants.baseUrl + 
          ApiConstants.createReservationPath(teacherId, areaId));
      
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(reservation.toJson(forPost: true)),
      );

      if (response.statusCode == HttpStatus.created || 
          response.statusCode == HttpStatus.ok) {
        return Reservation.fromJson(jsonDecode(response.body));
      }

      if (response.statusCode == HttpStatus.badRequest) {
        throw HttpException('Invalid reservation data (400)');
      }

      if (response.statusCode == HttpStatus.notFound) {
        throw HttpException('Teacher or area not found (404)');
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
      throw Exception('Unexpected error while creating reservation: $e');
    }
  }
}