class User {
  final String id;
  final String username;
  final String role;
  final String token;

  const User({
    required this.id,
    required this.username,
    required this.role,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
      token: json['token'] as String,
    );
  }
}
