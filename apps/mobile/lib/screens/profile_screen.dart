import 'package:flutter/material.dart';

import '../models/api_session.dart';
import '../models/api_user.dart';
import '../services/backend_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  String? errorText;
  ApiUser? user;
  List<ApiSession> sessions = const [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final totalSeconds = sessions.fold<int>(
      0,
      (sum, session) => sum + (session.duration ?? 0),
    );
    final subjectCounts = _subjectCounts(sessions);
    final displayName = user?.name ?? 'Student';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorText != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(errorText!),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: palette.surfaceCard,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  color: palette.chipBackground,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 44,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      user?.email ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: palette.textMuted),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children:
                                          subjectCounts.keys.map((subject) {
                                        return _Badge(
                                          label: _displaySubject(subject),
                                          color: _badgeColor(subject),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final first = StatCard(
                              title: 'Total Sessions',
                              value: '${sessions.length}',
                              subtitle: 'All learning conversations saved',
                              color: AppColors.primary,
                              compact: true,
                            );
                            final second = StatCard(
                              title: 'Hours Learned',
                              value: (totalSeconds / 3600).toStringAsFixed(1),
                              subtitle: 'Tracked from backend session duration',
                              color: AppColors.tertiary,
                              compact: true,
                            );

                            if (constraints.maxWidth < 380) {
                              return Column(
                                children: [
                                  first,
                                  const SizedBox(height: 16),
                                  second,
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(child: first),
                                const SizedBox(width: 16),
                                Expanded(child: second),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.20),
                                palette.tertiaryContainer
                                    .withValues(alpha: 0.26),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.insights_rounded,
                                color: AppColors.primary,
                                size: 36,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                sessions.isEmpty
                                    ? 'No sessions yet. Start a subject to build your learning record.'
                                    : 'You have studied ${subjectCounts.length} subjects with ${sessions.fold<int>(0, (sum, item) => sum + item.attemptCount)} total guiding rounds.',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      height: 1.5,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Live backend summary',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: AppColors.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _ActionTile(
                          icon: Icons.history_rounded,
                          title: 'Recent Session',
                          subtitle: sessions.isEmpty
                              ? 'No session history available yet.'
                              : _recentSessionText(sessions.first),
                        ),
                        const SizedBox(height: 12),
                        _ActionTile(
                          icon: Icons.bar_chart_rounded,
                          title: 'Top Subject',
                          subtitle: subjectCounts.isEmpty
                              ? 'No subject data available yet.'
                              : '${_displaySubject(subjectCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key)} has the most sessions.',
                        ),
                        const SizedBox(height: 12),
                        const _ActionTile(
                          icon: Icons.logout_rounded,
                          title: 'Log Out',
                          subtitle: 'Ends your backend-authenticated session.',
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Future<void> _loadProfile() async {
    try {
      final currentUser = await BackendApiService.instance.getMe();
      final sessionList = await BackendApiService.instance.getSessions();
      if (!mounted) return;
      setState(() {
        user = currentUser;
        sessions = sessionList;
        isLoading = false;
      });
    } on BackendApiException catch (error) {
      if (!mounted) return;
      setState(() {
        errorText = error.message;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        errorText = 'Failed to load profile data.';
        isLoading = false;
      });
    }
  }

  Map<String, int> _subjectCounts(List<ApiSession> items) {
    final counts = <String, int>{};
    for (final session in items) {
      counts.update(session.subject, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  String _displaySubject(String subject) {
    switch (subject) {
      case 'math':
        return 'Mathematics';
      case 'physics':
        return 'Physics';
      case 'chemistry':
        return 'Chemistry';
      case 'biology':
        return 'Biology';
      default:
        return subject;
    }
  }

  Color _badgeColor(String subject) {
    switch (subject) {
      case 'math':
        return const Color(0xFFC0ADFF);
      case 'physics':
        return const Color(0xFFDBF5F4);
      case 'chemistry':
        return const Color(0xFFD8FBF8);
      case 'biology':
        return const Color(0xFFD9F4E4);
      default:
        return const Color(0xFFE9ECFF);
    }
  }

  String _recentSessionText(ApiSession session) {
    final topic = session.topic?.trim();
    if (topic != null && topic.isNotEmpty) {
      return '${_displaySubject(session.subject)}: $topic';
    }
    return '${_displaySubject(session.subject)} session with ${session.messages.length} saved messages.';
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: palette.surfaceLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: palette.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
