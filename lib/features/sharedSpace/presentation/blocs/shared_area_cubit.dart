import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/domain/models/shared_area.dart';
import 'package:eduspace_flutter_app/features/sharedSpace/data/shared_area_service.dart';

abstract class SharedAreaState {}

class SharedAreaInitial extends SharedAreaState {}

class SharedAreaLoading extends SharedAreaState {}

class SharedAreaLoaded extends SharedAreaState {
  final List<SharedArea> areas;
  SharedAreaLoaded(this.areas);
}

class SharedAreaError extends SharedAreaState {
  final String message;
  SharedAreaError(this.message);
}

class SharedAreaCubit extends Cubit<SharedAreaState> {
  final SharedAreaService service;

  SharedAreaCubit({required this.service}) : super(SharedAreaInitial());

  Future<void> loadSharedAreas() async {
    emit(SharedAreaLoading());
    try {
      final areas = await service.getAllSharedAreas();
      emit(SharedAreaLoaded(areas));
    } catch (e) {
      emit(SharedAreaError(e.toString()));
    }
  }
}