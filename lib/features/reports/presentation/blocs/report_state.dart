import 'package:eduspace_flutter_app/features/reports/domain/report.dart';
import 'package:eduspace_flutter_app/features/reports/domain/resource_light.dart';

enum ReportStatus { initial, loading, success, failure }

class ReportState {
  final ReportStatus status;
  final List<ResourceLight> resources;
  final List<Report> reports;
  final String? selectedResourceId;
  final String? errorMessage;

  const ReportState({
    this.status = ReportStatus.initial,
    this.resources = const [],
    this.reports = const [],
    this.selectedResourceId,
    this.errorMessage,
  });

  ReportState copyWith({
    ReportStatus? status,
    List<ResourceLight>? resources,
    List<Report>? reports,
    String? selectedResourceId,
    String? errorMessage,
  }) {
    return ReportState(
      status: status ?? this.status,
      resources: resources ?? this.resources,
      reports: reports ?? this.reports,
      selectedResourceId: selectedResourceId ?? this.selectedResourceId,
      errorMessage: errorMessage,
    );
  }
}
