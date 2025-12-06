import 'dart:async';

import 'package:eduspace_flutter_app/features/reports/data/report_service.dart';
import 'package:eduspace_flutter_app/features/reports/data/resource_service.dart';
import 'package:eduspace_flutter_app/features/reports/domain/report.dart';
import 'package:eduspace_flutter_app/features/reports/domain/resource_light.dart';
import 'package:eduspace_flutter_app/features/reports/presentation/blocs/report_event.dart';
import 'package:eduspace_flutter_app/features/reports/presentation/blocs/report_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportService reportService;
  final ResourceService resourceService;

  ReportBloc({required this.reportService, required this.resourceService})
    : super(const ReportState()) {
    on<LoadResourcesForClassroom>(_onLoadResourcesForClassroom);
    on<LoadReportsForResource>(_onLoadReportsForResource);
    on<CreateReportEvent>(_onCreateReport);
  }

  FutureOr<void> _onLoadResourcesForClassroom(
    LoadResourcesForClassroom event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(status: ReportStatus.loading, errorMessage: null));
    try {
      final List<ResourceLight> resources = await resourceService
          .getResourcesByClassroom(event.classroomId);

      String? firstResourceId = resources.isNotEmpty
          ? resources.first.id
          : null;

      List<Report> reports = const [];
      if (firstResourceId != null) {
        reports = await reportService.getReportsByResource(firstResourceId);
      }

      emit(
        state.copyWith(
          status: ReportStatus.success,
          resources: resources,
          reports: reports,
          selectedResourceId: firstResourceId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ReportStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onLoadReportsForResource(
    LoadReportsForResource event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(status: ReportStatus.loading, errorMessage: null));
    try {
      final reports = await reportService.getReportsByResource(
        event.resourceId,
      );
      emit(
        state.copyWith(
          status: ReportStatus.success,
          reports: reports,
          selectedResourceId: event.resourceId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ReportStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onCreateReport(
    CreateReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(state.copyWith(status: ReportStatus.loading, errorMessage: null));
    try {
      await reportService.createReport(
        kindOfReport: event.kindOfReport,
        description: event.description,
        resourceId: event.resourceId,
      );

      final reports = await reportService.getReportsByResource(
        event.resourceId,
      );

      emit(
        state.copyWith(
          status: ReportStatus.success,
          reports: reports,
          selectedResourceId: event.resourceId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ReportStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
