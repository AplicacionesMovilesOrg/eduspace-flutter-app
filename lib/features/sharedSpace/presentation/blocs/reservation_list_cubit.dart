import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/reservation.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/data/reservation_service.dart';

abstract class ReservationListState {}

class ReservationListInitial extends ReservationListState {}

class ReservationListLoading extends ReservationListState {}

class ReservationListLoaded extends ReservationListState {
  final List<Reservation> reservations;
  ReservationListLoaded(this.reservations);
}

class ReservationListError extends ReservationListState {
  final String message;
  ReservationListError(this.message);
}

class ReservationListCubit extends Cubit<ReservationListState> {
  final ReservationService service;

  ReservationListCubit({required this.service})
    : super(ReservationListInitial());

  Future<void> loadTeacherReservations(String teacherId) async {
    emit(ReservationListLoading());
    try {
      final reservations = await service.getTeacherReservations(
        teacherId: teacherId,
      );
      emit(ReservationListLoaded(reservations));
    } catch (e) {
      emit(ReservationListError(e.toString()));
    }
  }
}
