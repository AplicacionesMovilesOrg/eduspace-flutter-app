import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  static const String signInEndpoint = '/Authentication/sign-in';
  static const String reservationsEndpoint = "/reservations";
  static const String sharedAreasEndpoint = "/shared-area";

  static String createReservationPath(String teacherId, String areaId) {
    return "/teachers/$teacherId/areas/$areaId/reservations";
  }

  static String getSharedAreaByIdPath(String areaId) {
    return "/shared-area/$areaId";
  }
}
