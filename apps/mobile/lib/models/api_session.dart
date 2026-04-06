import 'chat_message.dart';

class Collaborator {
  final String userId;
  final String access;
  final String? name;
  final String? email;

  Collaborator({
    required this.userId,
    required this.access,
    this.name,
    this.email,
  });

  factory Collaborator.fromJson(Map<String, dynamic> json) {
    // Check if userId is populated (is an object) or just an ID
    final userData = json['userId'];
    if (userData is Map<String, dynamic>) {
      return Collaborator(
        userId: (userData['_id'] ?? userData['id'] ?? '') as String,
        access: (json['access'] ?? 'read') as String,
        name: userData['name'] as String?,
        email: userData['email'] as String?,
      );
    }
    return Collaborator(
      userId: (userData ?? '') as String,
      access: (json['access'] ?? 'read') as String,
    );
  }
}

class ApiSession {
  final String id;
  final dynamic owner; // Can be String ID or Map (populated)
  final String subject;
  String topic;
  final bool isActive;
  final List<ChatMessage> messages;
  final List<Collaborator> collaborators;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? duration;
  final int? attemptCount;
  final DateTime? startedAt;

  ApiSession({
    required this.id,
    required this.owner,
    required this.subject,
    required this.topic,
    required this.messages,
    this.collaborators = const [],
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.duration = 0,
    this.attemptCount = 0,
    this.startedAt,
  });

  String get userId {
    if (owner is Map<String, dynamic>) {
      return (owner['_id'] ?? owner['id'] ?? '') as String;
    }
    return owner.toString();
  }

  String? get ownerName {
    if (owner is Map<String, dynamic>) {
      return owner['name'] as String?;
    }
    return null;
  }

  String get displayTitle {
    // If user has manually renamed the session, use that topic
    if (topic.isNotEmpty && topic != 'New Session' && topic != 'Untitled Session') {
      return topic;
    }

    // Default to first user message content
    if (messages.isNotEmpty) {
      final firstMessage = messages.firstWhere(
        (m) => m.role == 'user',
        orElse: () => messages.first,
      ).content.trim();
      
      if (firstMessage.isNotEmpty) {
        return firstMessage;
      }
    }

    return 'Untitled Session';
  }

  factory ApiSession.fromJson(Map<String, dynamic> json) {
    return ApiSession(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      owner: json['userId'],
      subject: (json['subject'] ?? '') as String,
      topic: (json['topic'] ?? '') as String,
      isActive: (json['isActive'] ?? true) as bool,
      duration: (json['duration'] ?? 0) as int?,
      attemptCount: (json['attemptCount'] ?? 0) as int?,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.tryParse(json['startedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.tryParse(json['updatedAt'] as String),
      messages: ((json['messages'] as List<dynamic>?) ?? const [])
          .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
          .toList(),
      collaborators: ((json['collaborators'] as List<dynamic>?) ?? const [])
          .map((item) => Collaborator.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
