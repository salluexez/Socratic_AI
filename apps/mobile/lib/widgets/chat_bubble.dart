import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../theme/app_theme.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final palette = context.palette;
    final radius = BorderRadius.only(
      topLeft: Radius.circular(isUser ? 30 : 10),
      topRight: Radius.circular(isUser ? 10 : 30),
      bottomLeft: const Radius.circular(30),
      bottomRight: const Radius.circular(30),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : palette.surfaceCard,
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: (isUser ? AppColors.primary : palette.outline)
                  .withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 12),
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
            if (!isUser && message.isHint) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: palette.surfaceLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_rounded,
                        color: AppColors.primary),
                    const SizedBox(width: 10),
                    Text(
                      'Hint 1/5 available',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.primary,
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
