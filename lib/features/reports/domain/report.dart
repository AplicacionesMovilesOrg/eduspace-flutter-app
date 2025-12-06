class Report {
  final String id;
  final String kindOfReport;
  final String description;
  final String resourceId;
  final DateTime createdAt;
  final String status;

  const Report({
    required this.id,
    required this.kindOfReport,
    required this.description,
    required this.resourceId,
    required this.createdAt,
    required this.status,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      kindOfReport: json['kindOfReport'] as String,
      description: json['description'] as String,
      resourceId: json['resourceId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
    );
  }
}
