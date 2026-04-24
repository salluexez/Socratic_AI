import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/api_session.dart';
import '../models/chat_message.dart';
import '../models/subject.dart';
import '../services/backend_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/ambient_background.dart';
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
  int _hintCount = 0;

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

  bool get _isOwner {
    if (_currentSessionId == null) return true; // New chat is always mine
    return _chatSession?.userId == BackendApiService.instance.currentUser?.id;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.args.subject.name,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              _currentSessionId == null ? 'NEW SESSION' : 'CURRENT SESSION',
              style: GoogleFonts.inter(
                    color: palette.primaryDim,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: palette.surfaceLow.withValues(alpha: isDark ? 0.4 : 0.6),
            ),
          ),
        ),
        actions: [
          if (_hintCount >= 3)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: isLoading ? null : _sendRevealRequest,
                icon: const Icon(Icons.visibility_rounded, size: 18),
                label: const Text('REVEAL'),
                style: TextButton.styleFrom(
                  foregroundColor: palette.primaryDim,
                  textStyle: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 11),
                ),
              ),
            ),
          if (_currentSessionId != null && _isOwner)
            IconButton(
              onPressed: () => _showShareDialog(_chatSession!),
              icon: const Icon(Icons.share_rounded, size: 20),
              tooltip: 'Share Chat',
            ),
          if (_isOwner)
            Builder(builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(Icons.history_rounded, size: 22),
                tooltip: 'Chat History',
              );
            }),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: Colors.transparent,
      endDrawer: _isOwner ? _buildHistoryDrawer(context) : null,
      body: AmbientBackground(
        child: SafeArea(
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: palette.surfaceCard.withValues(alpha: isDark ? 0.4 : 0.6),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: palette.outline.withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          3,
                                          (dotIndex) => _LoadingDot(index: dotIndex),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Synthesizing...',
                                  style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: palette.primaryDim,
                                      ),
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
            if (_chatSession?.collaborators.any((c) => c.userId == BackendApiService.instance.currentUser?.id) ?? false)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: palette.surfaceLow,
                  border: Border(top: BorderSide(color: palette.outline, width: 1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.visibility_rounded, size: 18, color: palette.textMuted),
                    const SizedBox(width: 8),
                    Text(
                      'You have view-only access to this chat',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: palette.textMuted,
                          ),
                    ),
                  ],
                ),
              )
            else
              _buildInputArea(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: palette.surfaceCard.withValues(alpha: isDark ? 0.3 : 0.6),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: palette.outline.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: isLoading || isBootstrapping
                      ? null
                      : _sendSimplifyRequest,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  color: palette.primaryDim,
                  tooltip: 'Simplify',
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    textInputAction: TextInputAction.send,
                    minLines: 1,
                    maxLines: 5,
                    enabled: !isLoading,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Share your thought...',
                      hintStyle: GoogleFonts.inter(
                        color: palette.textMuted.withValues(alpha: 0.5),
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                      suffixIcon: VoiceInputSuffix(controller: controller),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                _buildSendButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    final palette = context.palette;
    final isSending = isLoading || isBootstrapping;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isSending 
            ? [palette.surfaceLow, palette.surfaceLow]
            : [AppColors.primary, palette.primaryDim],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          if (!isSending)
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: IconButton(
        onPressed: isSending ? null : _sendMessage,
        icon: isSending 
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(palette.primaryDim),
                ),
              )
            : const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 22,
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

  Future<void> _renameSession(ApiSession session) async {
    final controller = TextEditingController(text: session.topic.isNotEmpty ? session.topic : session.displayTitle);
    
    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Session'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Session Name',
            hintText: 'Enter new name',
          ),
          onSubmitted: (value) => Navigator.pop(context, value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Rename'),
          ),
        ],
      ),
    );

    if (newTitle != null && newTitle.trim().isNotEmpty && newTitle != session.topic) {
      try {
        await BackendApiService.instance.renameSession(session.id, newTitle.trim());
        if (_currentSessionId == session.id) {
          _loadSession(); // Refresh current session
        }
        _loadSubjectHistory(); // Refresh history list
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session renamed')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to rename session: $e')),
          );
        }
      }
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

  Future<void> _showShareDialog(ApiSession session) async {
    final emailController = TextEditingController();
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Chat Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invite someone to view this chat. They will have read-only access.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.textMuted,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Invitee Email',
                hintText: 'user@example.com',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Share'),
          ),
        ],
      ),
    );

    if (result == true) {
      final email = emailController.text.trim();
      if (email.isEmpty) return;
      
      try {
        await BackendApiService.instance.shareSession(session.id, email);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chat shared with $email')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to share: $e')),
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
                    child: const Icon(Icons.history_rounded, color: AppColors.primary),
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 18),
                                    onPressed: () => _renameSession(session),
                                    color: isCurrent ? AppColors.primary.withValues(alpha: 0.7) : palette.textMuted,
                                    tooltip: 'Rename',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18),
                                    onPressed: () => _deleteSession(session.id),
                                    color: isCurrent ? AppColors.primary.withValues(alpha: 0.7) : Colors.red.withValues(alpha: 0.6),
                                    tooltip: 'Delete',
                                  ),
                                ],
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
    setState(() => _hintCount = 0); // Reset hints on a new manual message
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
    setState(() => _hintCount++); // Increment clicks
    await _submitUserMessage(
      'Please simplify this problem and break it into smaller steps.',
    );
  }

  Future<void> _sendRevealRequest() async {
    setState(() => _hintCount = 0); // Reset hints after revealing
    await _submitUserMessage(
      'I give up, please show me the full solution with reasoning.',
      revealAnswer: true,
    );
  }

  Future<void> _submitUserMessage(String text, {bool revealAnswer = false}) async {
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
        revealAnswer: revealAnswer,
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

class _LoadingDot extends StatefulWidget {
  final int index;
  const _LoadingDot({required this.index});

  @override
  State<_LoadingDot> createState() => _LoadingDotState();
}

class _LoadingDotState extends State<_LoadingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          widget.index * 0.2,
          0.6 + (widget.index * 0.2),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: context.palette.primaryDim.withValues(alpha: _animation.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
