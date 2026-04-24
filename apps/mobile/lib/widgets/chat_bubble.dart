import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(4),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
            bottomLeft: Radius.circular(4),
          );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: isUser 
                  ? palette.primaryDim.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: isUser ? 0 : 10, sigmaY: isUser ? 0 : 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isUser 
                    ? null 
                    : isDark 
                        ? palette.surfaceCard.withValues(alpha: 0.6) 
                        : palette.surfaceCard.withValues(alpha: 0.8),
                gradient: isUser
                    ? LinearGradient(
                        colors: [
                          palette.primaryDim,
                          palette.primaryDim.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: radius,
                border: Border.all(
                  color: isUser 
                      ? Colors.white.withValues(alpha: 0.1) 
                      : palette.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: GoogleFonts.inter(
                      color: isUser ? Colors.white : palette.text,
                      height: 1.5,
                      fontSize: 15,
                      fontWeight: isUser ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                  if (!isUser) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => TTSService.instance.speak(
                              message.content.hashCode.toString(),
                              message.content,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.volume_up_rounded,
                                size: 16,
                                color: palette.primaryDim.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (!isUser && message.isHint) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: palette.primaryDim.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: palette.primaryDim.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: palette.primaryDim.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.lightbulb_rounded,
                                color: palette.primaryDim, size: 16),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Hint available',
                            style: GoogleFonts.inter(
                                  color: palette.primaryDim,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

