class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.content,
    this.isHint = false,
  });

  final String role;
  final String content;
  final bool isHint;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: (json['role'] ?? 'assistant') as String,
      content: (json['content'] ?? '') as String,
      isHint: false,
    );
  }
}
