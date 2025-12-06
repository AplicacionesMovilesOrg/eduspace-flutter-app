import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduspace_flutter_app/features/reports/data/report_service.dart';
import 'package:eduspace_flutter_app/features/reports/domain/report_with_context.dart';

abstract class ReportDetailsState {}

class ReportDetailsInitial extends ReportDetailsState {}

class ReportDetailsLoaded extends ReportDetailsState {
  final ReportWithContext report;

  ReportDetailsLoaded(this.report);
}

class ReportDetailsUpdating extends ReportDetailsState {}

class ReportDetailsDeleting extends ReportDetailsState {}

class ReportDetailsError extends ReportDetailsState {
  final String message;

  ReportDetailsError(this.message);
}

class ReportDetailsSuccess extends ReportDetailsState {}

class ReportDetailsCubit extends Cubit<ReportDetailsState> {
  final ReportService service;

  ReportDetailsCubit({required this.service}) : super(ReportDetailsInitial());

  void loadReport(ReportWithContext report) {
    emit(ReportDetailsLoaded(report));
  }

  Future<void> updateReport({
    required String reportId,
    required String kindOfReport,
    required String description,
  }) async {
    emit(ReportDetailsUpdating());
    try {
      await service.updateReport(
        reportId: reportId,
        kindOfReport: kindOfReport,
        description: description,
      );
      emit(ReportDetailsSuccess());
    } catch (e) {
      emit(ReportDetailsError(e.toString()));
    }
  }

  Future<void> deleteReport(String reportId) async {
    emit(ReportDetailsDeleting());
    try {
      await service.deleteReport(reportId);
      emit(ReportDetailsSuccess());
    } catch (e) {
      emit(ReportDetailsError(e.toString()));
    }
  }
}
