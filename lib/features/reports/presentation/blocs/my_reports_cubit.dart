import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/features/reports/data/report_service.dart';
import 'package:eduspace_flutter_app/features/reports/domain/report_with_context.dart';

abstract class MyReportsState {}

class MyReportsInitial extends MyReportsState {}

class MyReportsLoading extends MyReportsState {}

class MyReportsLoaded extends MyReportsState {
  final List<ReportWithContext> reports;

  MyReportsLoaded(this.reports);
}

class MyReportsError extends MyReportsState {
  final String message;

  MyReportsError(this.message);
}

class MyReportsCubit extends Cubit<MyReportsState> {
  final ReportService service;

  MyReportsCubit({required this.service}) : super(MyReportsInitial());

  Future<void> loadTeacherReports(String teacherId) async {
    emit(MyReportsLoading());
    try {
      final reports = await service.getReportsByTeacher(teacherId);
      emit(MyReportsLoaded(reports));
    } catch (e) {
      emit(MyReportsError(e.toString()));
    }
  }
}
