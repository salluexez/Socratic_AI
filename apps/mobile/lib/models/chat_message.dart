class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.content,
    this.isHint = false,
  });

  final String role;
  final String content;
  final bool isHint;
}
