import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/Reservation.dart';

abstract class ReservationRepository {
  Future<Reservation> createReservation({
    required String teacherId,
    required String areaId,
    required String title,
    required DateTime start,
    required DateTime end,
  });
}