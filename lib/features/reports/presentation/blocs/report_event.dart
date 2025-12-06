abstract class ReportEvent {
  const ReportEvent();
}

class LoadResourcesForClassroom extends ReportEvent {
  final String classroomId;
  const LoadResourcesForClassroom({required this.classroomId});
}

class LoadReportsForResource extends ReportEvent {
  final String resourceId;
  const LoadReportsForResource({required this.resourceId});
}

class CreateReportEvent extends ReportEvent {
  final String kindOfReport;
  final String description;
  final String resourceId;

  const CreateReportEvent({
    required this.kindOfReport,
    required this.description,
    required this.resourceId,
  });
}
