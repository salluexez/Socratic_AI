import 'chat_message.dart';

class ApiSession {
  final String id;
  final String userId;
  final String subject;
  String topic;
  final bool isActive;
  final int? duration;
  final int attemptCount;
  final List<ChatMessage> messages;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? startedAt;

  ApiSession({
    required this.id,
    required this.userId,
    required this.subject,
    required this.topic,
    required this.messages,
    this.isActive = true,
    this.duration,
    this.attemptCount = 0,
    this.createdAt,
    this.updatedAt,
    this.startedAt,
  });

  String get displayTitle {
    if (messages.isNotEmpty) {
      final firstMessage = messages.first.content.trim();
      if (firstMessage.isNotEmpty) {
        return firstMessage;
      }
    }
    return topic.isNotEmpty ? topic : 'Untitled Session';
  }

  factory ApiSession.fromJson(Map<String, dynamic> json) {
    return ApiSession(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      userId: (json['userId'] ?? '') as String,
      subject: (json['subject'] ?? '') as String,
      topic: (json['topic'] ?? '') as String,
      isActive: (json['isActive'] ?? true) as bool,
      duration: (json['duration'] as num?)?.toInt(),
      attemptCount: ((json['attemptCount'] ?? 0) as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.tryParse(json['startedAt'] as String),
      messages: ((json['messages'] as List<dynamic>?) ?? const [])
          .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
