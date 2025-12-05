import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/features/classroom/domain/models/classroom.dart';
import 'package:eduspace_flutter_app/features/classroom/data/classroom_service.dart';
import 'package:eduspace_flutter_app/features/classroom/data/teacher_profile_service.dart';

abstract class ClassroomState {}

class ClassroomInitial extends ClassroomState {}

class ClassroomLoading extends ClassroomState {}

class ClassroomLoaded extends ClassroomState {
  final List<Classroom> classrooms;
  final String teacherId;

  ClassroomLoaded({required this.classrooms, required this.teacherId});
}

class ClassroomError extends ClassroomState {
  final String message;

  ClassroomError(this.message);
}

class ClassroomCubit extends Cubit<ClassroomState> {
  final ClassroomService _classroomService;
  final TeacherProfileService _teacherProfileService;

  ClassroomCubit({
    required ClassroomService classroomService,
    required TeacherProfileService teacherProfileService,
  }) : _classroomService = classroomService,
       _teacherProfileService = teacherProfileService,
       super(ClassroomInitial());

  Future<void> loadClassrooms(String accountId) async {
    emit(ClassroomLoading());
    try {
      final teacherProfile = await _teacherProfileService.getByAccountId(
        accountId,
      );
      final classrooms = await _classroomService.getByTeacherId(
        teacherProfile.id,
      );

      emit(
        ClassroomLoaded(classrooms: classrooms, teacherId: teacherProfile.id),
      );
    } catch (e) {
      emit(ClassroomError(e.toString()));
    }
  }
}
