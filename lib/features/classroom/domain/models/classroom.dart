class Classroom {
  final String id;
  final String name;
  final String description;
  final String teacherId;

  const Classroom({
    required this.id,
    required this.name,
    required this.description,
    required this.teacherId,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      teacherId: json['teacherId'] as String? ?? '',
    );
  }
}
