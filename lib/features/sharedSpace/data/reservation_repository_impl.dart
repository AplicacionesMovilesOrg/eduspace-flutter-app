import 'package:eduspace_flutter_app/features/sharedSpace/data/reservation_service.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/Reservation.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationService service;

  const ReservationRepositoryImpl({required this.service});

  @override
  Future<Reservation> createReservation({
    required String teacherId,
    required String areaId,
    required String title,
    required DateTime start,
    required DateTime end,
  }) async {
    if (title.trim().isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    
    if (end.isBefore(start) || end.isAtSameMomentAs(start)) {
      throw ArgumentError('End time must be after start time');
    }

    final reservation = Reservation(
      title: title.trim(),
      start: start,
      end: end,
    );

    return await service.createReservation(
      teacherId: teacherId,
      areaId: areaId,
      reservation: reservation,
    );
  }
}