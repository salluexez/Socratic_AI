import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../theme/app_theme.dart';
import '../services/tts_service.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(10),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
            bottomLeft: Radius.circular(10),
          );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? palette.primaryDim : palette.surfaceCard,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : palette.text.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isUser ? Colors.white : palette.text,
                  ),
            ),
            if (!isUser) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () => TTSService.instance.speak(
                    message.content.hashCode.toString(),
                    message.content,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.volume_up_rounded,
                      size: 18,
                      color: palette.primaryDim.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ],
            if (!isUser && message.isHint) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: palette.surfaceLow,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: palette.outline, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_rounded,
                        color: palette.primaryDim),
                    const SizedBox(width: 10),
                    Text(
                      'Hint 1/5 available',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: palette.primaryDim,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
