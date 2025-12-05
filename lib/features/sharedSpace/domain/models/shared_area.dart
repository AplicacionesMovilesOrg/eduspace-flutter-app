class SharedArea {
  final String id;
  final String name;
  final String description;
  final int capacity;

  SharedArea({
    required this.id,
    required this.name,
    required this.description,
    required this.capacity,
  });

  factory SharedArea.fromJson(Map<String, dynamic> json) {
    return SharedArea(
      id: json['id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      capacity: json['capacity'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'capacity': capacity,
    };
  }

  @override
  String toString() {
    return 'SharedArea(id: $id, name: $name, description: $description, capacity: $capacity)';
  }
}
