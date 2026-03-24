import 'package:flutter/material.dart';

import '../theme/theme_controller.dart';
import '../models/api_session.dart';
import '../models/chat_message.dart';
import '../models/subject.dart';
import '../services/backend_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/voice_input_suffix.dart';
import 'package:intl/intl.dart';

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
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  final List<ChatMessage> messages = [];
  bool isLoading = false;
  bool isBootstrapping = true;
  String? errorText;
  String? _currentSessionId;
  List<ApiSession> _subjectSessions = [];
  bool _isLoadingHistory = false;
  ApiSession? _chatSession;

  @override
  void initState() {
    super.initState();
    _currentSessionId = widget.args.sessionId;
    _loadSession();
    _loadSubjectHistory();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
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
          IconButton(
            onPressed: () => ThemeControllerScope.of(context).next(),
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Switch Theme',
          ),
          if (messages.where((m) => m.role == 'user').length >= 3)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton.tonalIcon(
                onPressed: isLoading ? null : _sendRevealRequest,
                icon: const Icon(Icons.visibility_rounded, size: 18),
                label: const Text('Show Answer'),
              ),
            ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.history_rounded),
              tooltip: 'Chat History',
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      endDrawer: _buildHistoryDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isBootstrapping
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
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
                      focusNode: _focusNode,
                      autofocus: true,
                      textInputAction: TextInputAction.send,
                      minLines: 1,
                      maxLines: 4,
                      enabled: !isLoading, // Allow typing even while bootstrapping
                      decoration: InputDecoration(
                        hintText: 'Share your thought...',
                        suffixIcon: VoiceInputSuffix(controller: controller),
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
      if (mounted) {
        setState(() {
          isBootstrapping = false;
        });
        _focusNode.requestFocus();
      }
      return;
    }

    try {
      final session =
          await BackendApiService.instance.getSessionById(_currentSessionId!);
      if (!mounted) return;
      setState(() {
        _chatSession = session;
        messages
          ..clear()
          ..addAll(session.messages);
        isBootstrapping = false;
      });
      _scrollToBottom();
      _focusNode.requestFocus();
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

  Future<void> _loadSubjectHistory() async {
    setState(() => _isLoadingHistory = true);
    try {
      final sessions = await BackendApiService.instance
          .getSessions(subject: widget.args.subject.slug);
      if (!mounted) return;
      setState(() {
        _subjectSessions = sessions;
        _isLoadingHistory = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingHistory = false);
    }
  }

  Future<void> _startNewSession() async {
    _switchToSession(null);
  }

  Future<void> _deleteSession(String sessionId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Session'),
        content: const Text('Are you sure you want to delete this session? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await BackendApiService.instance.deleteSession(sessionId);
        if (_currentSessionId == sessionId) {
          // If we deleted the active session, start a new one
          await _startNewSession();
        } else {
          // Just refresh history
          _loadSubjectHistory();
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete session: $e')),
          );
        }
      }
    }
  }

  void _switchToSession(String? sessionId) {
    if (_currentSessionId == sessionId) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      _currentSessionId = sessionId;
      messages.clear();
      isBootstrapping = (sessionId != null);
      errorText = null;
    });
    _focusNode.requestFocus();
    Navigator.pop(context);
    if (sessionId != null) {
      _loadSession();
    }
  }

  Widget _buildHistoryDrawer(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: palette.surfaceLow,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.history_rounded, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.add_circle_outline_rounded,
                  color: palette.textMuted),
              title: const Text('Start New Session'),
              onTap: () => _switchToSession(null),
            ),
            const Divider(height: 1),
            Expanded(
              child: _isLoadingHistory
                  ? const Center(child: CircularProgressIndicator())
                  : _subjectSessions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline_rounded,
                                  size: 48, color: palette.textMuted),
                              const SizedBox(height: 12),
                              Text(
                                'No previous sessions',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: palette.textMuted,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _subjectSessions.length,
                          itemBuilder: (context, index) {
                            final session = _subjectSessions[index];
                            final isCurrent = session.id == _currentSessionId;
                            final formattedDate = session.createdAt != null
                                ? DateFormat('MMM d, h:mm a')
                                    .format(session.createdAt!)
                                : 'Unknown date';

                            return ListTile(
                              selected: isCurrent,
                              selectedTileColor:
                                  AppColors.primary.withValues(alpha: 0.08),
                              leading: Icon(
                                Icons.chat_outlined,
                                color: isCurrent
                                    ? AppColors.primary
                                    : palette.textMuted,
                              ),
                              title: Text(
                                session.displayTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: isCurrent
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isCurrent ? AppColors.primary : null,
                                ),
                              ),
                              subtitle: Text(
                                formattedDate,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: palette.textMuted,
                                    ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                onPressed: () => _deleteSession(session.id),
                                color: isCurrent ? AppColors.primary.withOpacity(0.7) : Colors.red.withOpacity(0.6),
                              ),
                              onTap: () => _switchToSession(session.id),
                            );
                          },
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
    _focusNode.requestFocus();
    await _submitUserMessage(text);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
    _scrollToBottom();

    try {
      if (_currentSessionId == null) {
        final session = await BackendApiService.instance.createSession(
          subject: widget.args.subject.slug,
        );
        _currentSessionId = session.id;
        _chatSession = session;
      }

      final result = await BackendApiService.instance.sendChatMessage(
        sessionId: _currentSessionId!,
        content: text,
      );

      if (!mounted) return;
      setState(() {
        messages.add(ChatMessage(role: 'assistant', content: result.reply));
        if (result.topic != null) {
          if (_chatSession != null) {
            _chatSession!.topic = result.topic!;
          }
          // Also update in the list if it exists there
          final index = _subjectSessions.indexWhere((s) => s.id == _currentSessionId);
          if (index != -1) {
            _subjectSessions[index].topic = result.topic!;
          }
        }
        isLoading = false;
      });
      _scrollToBottom();
      _focusNode.requestFocus();
      _loadSubjectHistory(); // Refresh history list
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
