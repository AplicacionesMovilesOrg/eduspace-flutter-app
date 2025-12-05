import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/Reservation.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/reservation_repository.dart';

abstract class ReservationState {}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationSuccess extends ReservationState {
  final Reservation reservation;
  ReservationSuccess(this.reservation);
}

class ReservationError extends ReservationState {
  final String message;
  ReservationError(this.message);
}

class ReservationCubit extends Cubit<ReservationState> {
  final ReservationRepository repository;

  ReservationCubit({required this.repository}) : super(ReservationInitial());

  Future<void> createReservation({
    required String teacherId,
    required String areaId,
    required String title,
    required DateTime start,
    required DateTime end,
  }) async {
    emit(ReservationLoading());
    try {
      final reservation = await repository.createReservation(
        teacherId: teacherId,
        areaId: areaId,
        title: title,
        start: start,
        end: end,
      );
      emit(ReservationSuccess(reservation));
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }

  void reset() {
    emit(ReservationInitial());
  }
}