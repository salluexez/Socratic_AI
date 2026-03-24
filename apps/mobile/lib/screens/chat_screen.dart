import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../models/subject.dart';
import '../services/app_config.dart';
import '../services/gemini_service.dart';
import '../services/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';

class ChatScreenArgs {
  const ChatScreenArgs({required this.subject});

  final Subject subject;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.args});

  static const routeName = '/chat';

  final ChatScreenArgs args;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final List<ChatMessage> messages;
  final controller = TextEditingController();
  final geminiService = GeminiService();
  bool isLoading = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
    messages =
        MockDataService.starterConversation(widget.args.subject.name).toList();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.args.subject.name),
            Text(
              AppConfig.hasGeminiKey ? 'Gemini live' : 'Demo mode',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppConfig.hasGeminiKey ? null : Colors.orange,
                  ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.tonalIcon(
              onPressed: isLoading ? null : _sendRevealRequest,
              icon: const Icon(Icons.visibility_rounded),
              label: const Text('Show Answer'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                itemCount: messages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isLoading && index == messages.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: palette.surfaceLow,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              children: List.generate(
                                3,
                                (dotIndex) => Container(
                                  width: 8,
                                  height: 8,
                                  margin: EdgeInsets.only(
                                    right: dotIndex == 2 ? 0 : 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.35 + (dotIndex * 0.2),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Synthesizing thought...',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    );
                  }

                  return ChatBubble(message: messages[index]);
                },
              ),
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    errorText!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: BoxDecoration(
                color: palette.inputBar,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: 24,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: isLoading ? null : _sendSimplifyRequest,
                    icon: const Icon(Icons.lightbulb_rounded),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        hintText: 'Share your thought...',
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.primary, palette.primaryDim],
                      ),
                    ),
                    child: IconButton(
                      onPressed: isLoading ? null : _sendMessage,
                      icon: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    controller.clear();
    await _submitUserMessage(text);
  }

  Future<void> _sendSimplifyRequest() async {
    await _submitUserMessage(
      'Please simplify this problem and break it into smaller steps.',
    );
  }

  Future<void> _sendRevealRequest() async {
    await _submitUserMessage(
      'I give up, please show me the full solution with reasoning.',
      revealAnswer: true,
    );
  }

  Future<void> _submitUserMessage(
    String text, {
    bool revealAnswer = false,
  }) async {
    final userMessage = ChatMessage(role: 'user', content: text);

    setState(() {
      messages.add(userMessage);
      isLoading = true;
      errorText = null;
    });

    try {
      final reply = AppConfig.hasGeminiKey
          ? await geminiService.sendMessage(
              subject: widget.args.subject,
              history: messages,
              revealAnswer: revealAnswer,
            )
          : _demoReply(text, revealAnswer: revealAnswer);

      if (!mounted) return;
      setState(() {
        messages.add(ChatMessage(role: 'assistant', content: reply));
        isLoading = false;
      });
    } on GeminiException catch (error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorText = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorText =
            'Something went wrong while contacting Gemini. Please try again.';
      });
    }
  }

  String _demoReply(String text, {required bool revealAnswer}) {
    if (revealAnswer) {
      return 'Let me walk you through the solution step by step. Start by identifying the core concept, then apply the relevant rule carefully to each part of the problem.';
    }

    if (text.toLowerCase().contains('simplify')) {
      return 'Sure. Let us reduce it to the next smallest step: what is the one formula, definition, or principle that this problem depends on first?';
    }

    return 'Nice attempt. Before jumping ahead, which concept or formula are you choosing here, and why does it fit this situation?';
  }
}
