import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../models/subject.dart';
import '../services/backend_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';

class ChatScreenArgs {
  const ChatScreenArgs({
    required this.subject,
    this.sessionId,
  });

  final Subject subject;
  final String? sessionId;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.args});

  static const routeName = '/chat';

  final ChatScreenArgs args;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final List<ChatMessage> messages = [];
  bool isLoading = false;
  bool isBootstrapping = true;
  String? errorText;
  String? _currentSessionId;

  @override
  void initState() {
    super.initState();
    _currentSessionId = widget.args.sessionId;
    _loadSession();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.args.subject.name),
            Text(
              _currentSessionId == null ? 'New session' : 'Current session',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: palette.textMuted,
                  ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: isDark
            ? ClipRect(
                child: BackdropFilter(
                  filter: ColorFilter.mode(
                    palette.surfaceLow.withValues(alpha: 0.8),
                    BlendMode.srcOver,
                  ),
                  child: Container(color: Colors.transparent),
                ),
              )
            : null,
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
              child: isBootstrapping
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
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
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color: palette.inputBar,
                border: isDark ? Border(top: BorderSide(color: palette.outline, width: 1)) : null,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withValues(alpha: 0.2) : AppColors.primary.withValues(alpha: 0.04),
                    blurRadius: 24,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: isLoading || isBootstrapping
                        ? null
                        : _sendSimplifyRequest,
                    icon: const Icon(Icons.lightbulb_rounded),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      enabled: !isLoading && !isBootstrapping,
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
                      onPressed:
                          isLoading || isBootstrapping ? null : _sendMessage,
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

  Future<void> _loadSession() async {
    if (_currentSessionId == null || _currentSessionId!.isEmpty) {
      setState(() {
        isBootstrapping = false;
      });
      return;
    }

    try {
      final session =
          await BackendApiService.instance.getSessionById(_currentSessionId!);
      if (!mounted) return;
      setState(() {
        messages
          ..clear()
          ..addAll(session.messages);
        isBootstrapping = false;
      });
    } on BackendApiException catch (error) {
      if (!mounted) return;
      setState(() {
        errorText = error.message;
        isBootstrapping = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        errorText = 'Failed to load chat history.';
        isBootstrapping = false;
      });
    }
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
    );
  }

  Future<void> _submitUserMessage(String text) async {
    final userMessage = ChatMessage(role: 'user', content: text);
    setState(() {
      messages.add(userMessage);
      isLoading = true;
      errorText = null;
    });

    try {
      if (_currentSessionId == null) {
        final session = await BackendApiService.instance.createSession(
          subject: widget.args.subject.slug,
        );
        _currentSessionId = session.id;
      }

      final reply = await BackendApiService.instance.sendChatMessage(
        sessionId: _currentSessionId!,
        content: text,
      );

      if (!mounted) return;
      setState(() {
        messages.add(ChatMessage(role: 'assistant', content: reply));
        isLoading = false;
      });
    } on BackendApiException catch (error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorText = error.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorText = 'Something went wrong while sending the message.';
      });
    }
  }
}
