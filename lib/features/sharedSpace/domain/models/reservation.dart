class Reservation {
  final String? id; 
  final String title;
  final DateTime start;
  final DateTime end;
  final String? areaId; 
  final String? teacherId;

  Reservation({
    this.id,
    required this.title,
    required this.start,
    required this.end,
    this.areaId,
    this.teacherId,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id']?.toString(), 
      title: json['title'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      areaId: json['areaId']?.toString(),
      teacherId: json['teacherId']?.toString(),
    );
  }

  Map<String, dynamic> toJson({bool forPost = false}) {
    return {
      'title': title,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Reservation(id: $id, title: $title, start: $start, end: $end, areaId: $areaId, teacherId: $teacherId)';
  }
}