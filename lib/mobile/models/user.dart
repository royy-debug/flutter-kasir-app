class User {
  final int userId;
  final String username;
  final String role; // 'admin' | 'kasir'
  final DateTime createdAt;

  const User({
    required this.userId,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json['user_id'] as int,
        username: json['username'] as String,
        role: json['role'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'username': username,
        'role': role,
        'created_at': createdAt.toIso8601String(),
      };
}