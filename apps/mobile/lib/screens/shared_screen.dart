import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/backend_api_service.dart';
import '../models/api_session.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';
import '../models/subject.dart';

class SharedScreen extends StatefulWidget {
  const SharedScreen({super.key});

  @override
  State<SharedScreen> createState() => _SharedScreenState();
}

class _SharedScreenState extends State<SharedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ApiSession> _sharedWithMe = [];
  List<ApiSession> _sharedByMe = [];
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData(showLoading: true);
    _startPolling();
    
    // Refresh when data changes elsewhere
    BackendApiService.instance.refreshNotifier.addListener(_handleDataChanged);
  }

  void _startPolling() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) {
        _loadData(showLoading: false);
      }
    });
  }

  void _handleDataChanged() {
    _loadData(showLoading: false);
  }

  @override
  void dispose() {
    BackendApiService.instance.refreshNotifier.removeListener(_handleDataChanged);
    _refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData({bool showLoading = true}) async {
    if (!mounted) return;
    if (showLoading) {
      setState(() => _isLoading = true);
    }
    
    try {
      final results = await Future.wait([
        BackendApiService.instance.getSharedToMe(),
        BackendApiService.instance.getSharedByMe(),
      ]);
      
      if (!mounted) return;
      setState(() {
        _sharedWithMe = results[0];
        _sharedByMe = results[1];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (showLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load shared sessions: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
            child: Text(
              'Intellectual Circles',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: palette.text,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: palette.textMuted,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Shared with me'),
                Tab(text: 'Shared by me'),
              ],
            ),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSessionList(_sharedWithMe, isSharedByMe: false),
                    _buildSessionList(_sharedByMe, isSharedByMe: true),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList(List<ApiSession> sessions, {required bool isSharedByMe}) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded, size: 64, color: context.palette.textMuted.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'No shared sessions yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.palette.textMuted,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final ownerName = session.ownerName ?? 'Unknown';
        final formattedDate = session.updatedAt != null 
            ? DateFormat('MMM d, yyyy').format(session.updatedAt!)
            : 'Recently';

        Widget card = Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: context.palette.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.isDark ? context.palette.outline : context.palette.outline.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: context.isDark 
                    ? Colors.black.withValues(alpha: 0.3) 
                    : context.palette.text.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _handleSessionTap(session, isSharedByMe),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.displayTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: context.palette.text,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                isSharedByMe ? Icons.share_rounded : Icons.person_outline_rounded,
                                size: 14,
                                color: context.palette.textMuted,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                isSharedByMe 
                                  ? 'Shared with ${session.collaborators.length} users'
                                  : 'Shared by $ownerName',
                                style: TextStyle(color: context.palette.textMuted, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(color: context.palette.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            session.subject.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isSharedByMe && session.collaborators.isNotEmpty) 
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Icon(Icons.manage_accounts_rounded, size: 18, color: context.palette.primaryDim),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        if (isSharedByMe) {
          return Dismissible(
            key: Key('shared_by_me_${session.id}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade900.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.person_remove_rounded, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await _confirmUnshare(session);
            },
            onDismissed: (direction) {
              _unshareSession(session);
            },
            child: card,
          );
        }

        return card;
      },
    );
  }

  void _handleSessionTap(ApiSession session, bool isSharedByMe) {
    if (isSharedByMe && session.collaborators.isNotEmpty) {
      _showCollaboratorsModal(session);
    } else {
      Navigator.pushNamed(
        context,
        ChatScreen.routeName,
        arguments: ChatScreenArgs(
          subject: Subject(
            name: session.subject,
            slug: session.subject.toLowerCase(),
            description: 'Shared session',
            icon: Icons.school_rounded,
            accent: AppColors.primary,
          ),
          sessionId: session.id,
        ),
      );
    }
  }

  Future<bool?> _confirmUnshare(ApiSession session) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.palette.surfaceLow,
        title: const Text('Revoke All Access?'),
        content: Text('This will remove access for all collaborators on "${session.displayTitle}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: context.palette.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );
  }

  Future<void> _unshareSession(ApiSession session) async {
    try {
      await BackendApiService.instance.unshareSession(session.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access revoked successfully')),
      );
      _loadData();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to revoke access: $e')),
      );
    }
  }

  void _showCollaboratorsModal(ApiSession session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.palette.surfaceLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Collaborators',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: session.collaborators.length,
                      itemBuilder: (context, index) {
                        final collab = session.collaborators[index];
                        final hasName = collab.name != null && collab.name!.isNotEmpty;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            child: Text(
                              hasName ? collab.name![0].toUpperCase() : '?',
                              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(collab.name ?? 'Unknown User'),
                          subtitle: Text(collab.email ?? '', style: TextStyle(color: context.palette.textMuted, fontSize: 12)),
                          trailing: IconButton(
                            icon: const Icon(Icons.person_remove_rounded, color: Colors.redAccent, size: 20),
                            onPressed: () async {
                              try {
                                await BackendApiService.instance.removeCollaborator(session.id, collab.userId);
                                if (!context.mounted) return;
                                setModalState(() {
                                  session.collaborators.removeWhere((c) => c.userId == collab.userId);
                                });
                                _loadData();
                                if (session.collaborators.isEmpty) {
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to remove collaborator: $e')),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  if (session.collaborators.length > 1)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final success = await _confirmUnshare(session);
                            if (success == true) {
                              if (!context.mounted) return;
                              await _unshareSession(session);
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.delete_sweep_rounded, size: 20),
                          label: const Text('Revoke All Access'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.redAccent),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
