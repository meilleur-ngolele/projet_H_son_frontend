class User {
  final int id;
  final String name;
  final String email;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isVerified: json['email_verified_at'] != null || json['is_verified'] == true,
    );
  }
}