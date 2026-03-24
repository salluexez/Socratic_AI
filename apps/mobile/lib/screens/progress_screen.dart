import 'package:flutter/material.dart';

import '../models/api_session.dart';
import '../services/backend_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  bool isLoading = true;
  String? errorText;
  List<ApiSession> sessions = const [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final totalSeconds = sessions.fold<int>(
      0,
      (sum, session) => sum + (session.duration ?? 0),
    );
    final totalHours = (totalSeconds / 3600).toStringAsFixed(1);
    final activeSessions = sessions.where((session) => session.isActive).length;
    final subjectCounts = _subjectCounts(sessions);
    final chartData = _weeklyChart(sessions);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Progress')),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorText != null
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(errorText!),
                  ))
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: palette.heroBackground,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Intellectual Journey',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'You have completed ${sessions.length} sessions across ${subjectCounts.length} subjects.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: palette.textMuted),
                              ),
                              const SizedBox(height: 18),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final cards = [
                                    StatCard(
                                      title: 'Hours Spent',
                                      value: totalHours,
                                      subtitle: 'From completed sessions',
                                      color: AppColors.primary,
                                      compact: true,
                                    ),
                                    StatCard(
                                      title: 'Active Sessions',
                                      value: '$activeSessions',
                                      subtitle:
                                          'Currently open learning threads',
                                      color: AppColors.secondary,
                                      compact: true,
                                    ),
                                  ];

                                  if (constraints.maxWidth < 380) {
                                    return Column(
                                      children: [
                                        cards[0],
                                        const SizedBox(height: 12),
                                        cards[1],
                                      ],
                                    );
                                  }

                                  return Row(
                                    children: [
                                      Expanded(child: cards[0]),
                                      const SizedBox(width: 12),
                                      Expanded(child: cards[1]),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: palette.surfaceCard,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sessions This Week',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Real activity based on backend session history',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: palette.textMuted),
                              ),
                              const SizedBox(height: 22),
                              SizedBox(
                                height: 220,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children:
                                      List.generate(chartData.length, (index) {
                                    final entry = chartData[index];
                                    final maxValue = chartData
                                        .map((item) => item.$2)
                                        .fold<int>(0, (a, b) => a > b ? a : b);
                                    final value = entry.$2;
                                    final barFactor =
                                        maxValue == 0 ? 0.08 : value / maxValue;

                                    return Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  height: 170 * barFactor,
                                                  decoration: BoxDecoration(
                                                    color: value > 0
                                                        ? AppColors.primary
                                                        : AppColors.primary
                                                            .withValues(
                                                                alpha: 0.18),
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                      top: Radius.circular(999),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              entry.$1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium
                                                  ?.copyWith(
                                                    color: value > 0
                                                        ? AppColors.primary
                                                        : palette.textMuted,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final cards = [
                              StatCard(
                                title: 'Subjects Studied',
                                value: '${subjectCounts.length}',
                                subtitle: 'Distinct subjects in your sessions',
                                color: AppColors.secondary,
                              ),
                              StatCard(
                                title: 'Guiding Rounds',
                                value:
                                    '${sessions.fold<int>(0, (sum, s) => sum + s.attemptCount)}',
                                subtitle: 'Total Socratic follow-up attempts',
                                color: AppColors.tertiary,
                              ),
                            ];

                            if (constraints.maxWidth < 380) {
                              return Column(
                                children: [
                                  cards[0],
                                  const SizedBox(height: 16),
                                  cards[1],
                                ],
                              );
                            }

                            return Row(
                              children: [
                                Expanded(child: cards[0]),
                                const SizedBox(width: 16),
                                Expanded(child: cards[1]),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Future<void> _loadSessions() async {
    try {
      final result = await BackendApiService.instance.getSessions();
      if (!mounted) return;
      setState(() {
        sessions = result;
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
        errorText = 'Failed to load progress data.';
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

  List<(String, int)> _weeklyChart(List<ApiSession> items) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final counts = List<int>.filled(7, 0);

    for (final session in items) {
      final date = session.startedAt ?? session.createdAt;
      if (date == null) continue;
      final weekdayIndex = (date.weekday - 1).clamp(0, 6);
      counts[weekdayIndex] += 1;
    }

    return List.generate(
        labels.length, (index) => (labels[index], counts[index]));
  }
}
