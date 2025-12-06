class ReportWithContext {
  final String id;
  final String kindOfReport;
  final String description;
  final String resourceId;
  final String resourceName;
  final String classroomId;
  final String classroomName;
  final DateTime createdAt;
  final String status;

  const ReportWithContext({
    required this.id,
    required this.kindOfReport,
    required this.description,
    required this.resourceId,
    required this.resourceName,
    required this.classroomId,
    required this.classroomName,
    required this.createdAt,
    required this.status,
  });

  factory ReportWithContext.fromJson(Map<String, dynamic> json) {
    return ReportWithContext(
      id: json['id'] as String,
      kindOfReport: json['kindOfReport'] as String,
      description: json['description'] as String,
      resourceId: json['resourceId'] as String,
      resourceName: json['resourceName'] as String,
      classroomId: json['classroomId'] as String,
      classroomName: json['classroomName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
    );
  }
}
