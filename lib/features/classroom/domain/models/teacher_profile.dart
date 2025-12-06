class TeacherProfile {
  final String id;
  final String accountId;
  final String firstName;
  final String lastName;
  final String email;
  final String dni;
  final String address;
  final String phone;

  const TeacherProfile({
    required this.id,
    required this.accountId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dni,
    required this.address,
    required this.phone,
  });

  factory TeacherProfile.fromJson(Map<String, dynamic> json) {
    return TeacherProfile(
      id: json['id'] as String? ?? '',
      accountId: json['accountId'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      dni: json['dni'] as String? ?? '',
      address: json['address'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}
