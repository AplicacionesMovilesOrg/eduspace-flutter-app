class ResourceLight {
  final String id;
  final String name;

  const ResourceLight({required this.id, required this.name});

  factory ResourceLight.fromJson(Map<String, dynamic> json) {
    return ResourceLight(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
