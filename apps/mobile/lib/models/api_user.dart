class ApiUser {
  ApiUser({
    required this.id,
    required this.name,
    required this.email,
    this.notificationsEnabled = true,
    this.streak = 0,
  });

  final String id;
  final String name;
  final String email;
  bool notificationsEnabled;
  final int streak;

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
      id: (json['id'] ?? json['_id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      streak: (json['streak'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'notificationsEnabled': notificationsEnabled,
      'streak': streak,
    };
  }
}
