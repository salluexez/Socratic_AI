import 'chat_message.dart';

class ApiSession {
  const ApiSession({
    required this.id,
    required this.subject,
    required this.isActive,
    this.topic,
    this.duration,
    this.attemptCount = 0,
    this.createdAt,
    this.startedAt,
    this.messages = const [],
  });

  final String id;
  final String subject;
  final bool isActive;
  final String? topic;
  final int? duration;
  final int attemptCount;
  final DateTime? createdAt;
  final DateTime? startedAt;
  final List<ChatMessage> messages;

  factory ApiSession.fromJson(Map<String, dynamic> json) {
    return ApiSession(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      subject: (json['subject'] ?? '') as String,
      isActive: (json['isActive'] ?? false) as bool,
      topic: json['topic'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      attemptCount: ((json['attemptCount'] ?? 0) as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.tryParse(json['startedAt'] as String),
      messages: ((json['messages'] as List<dynamic>?) ?? const [])
          .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
