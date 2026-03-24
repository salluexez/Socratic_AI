import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalSeconds = sessions.fold<int>(
      0,
      (sum, session) => sum + (session.duration ?? 0),
    );
    final totalHoursNum = totalSeconds / 3600;
    final totalHours = totalHoursNum.toStringAsFixed(1);
    final subjectCounts = _subjectCounts(sessions);
    final chartData = _weeklyHourChart(sessions);

    return Container(
      color: palette.surfaceLow,
      child: SafeArea(
        bottom: false,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorText != null
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(errorText!),
                  ))
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Custom Header
                        Row(
                          children: [
                            Text(
                              'Your Progress',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    fontSize: 28,
                                    letterSpacing: -0.5,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Main Hero Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: palette.primaryGradient,
                            borderRadius: BorderRadius.circular(32),
                            border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1) : null,
                            boxShadow: [
                              BoxShadow(
                                color: palette.primaryDim.withValues(alpha: isDark ? 0.3 : 0.2),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Intellectual Journey',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'You have completed ${sessions.length} sessions across ${subjectCounts.length} subjects with ${totalHours} total focus hours.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.85),
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Stats Grid
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.0,
                          children: [
                            StatCard(
                              title: 'Hours Spent',
                              value: totalHours,
                              subtitle: 'Total focus time',
                              color: const Color(0xFF494ADB),
                              icon: Icons.timer_rounded,
                            ),
                            StatCard(
                              title: 'Sessions',
                              value: '${sessions.length}',
                              subtitle: 'Completed learning',
                              color: const Color(0xFF00BFA5),
                              icon: Icons.auto_graph_rounded,
                            ),
                            StatCard(
                              title: 'Subjects',
                              value: '${subjectCounts.length}',
                              subtitle: 'Areas explored',
                              color: const Color(0xFFFF9100),
                              icon: Icons.collections_bookmark_rounded,
                            ),
                            StatCard(
                              title: 'Rounds',
                              value:
                                  '${sessions.fold<int>(0, (sum, s) => sum + s.attemptCount)}',
                              subtitle: 'AI interactions',
                              color: const Color(0xFF6200EA),
                              icon: Icons.forum_rounded,
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // Chart Section
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: palette.surfaceCard,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: palette.text.withValues(alpha: 0.03),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Activity This Week',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Hours spent studying',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: palette.textMuted,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: palette.surfaceLow,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.bar_chart_rounded,
                                        size: 20, color: palette.primaryDim),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                height: 180,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children:
                                      List.generate(chartData.length, (index) {
                                    final entry = chartData[index];
                                    final maxValue = chartData
                                        .map((item) => item.$2)
                                        .fold<double>(
                                            0.0, (a, b) => a > b ? a : b);
                                    final value = entry.$2;
                                    final barFactor = maxValue == 0
                                        ? 0.05
                                        : (value / maxValue).clamp(0.05, 1.0);

                                    return Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                width: 14,
                                                height: 140 * barFactor,
                                                decoration: BoxDecoration(
                                                  gradient: value > 0
                                                      ? palette.primaryGradient
                                                      : null,
                                                  color: value > 0
                                                      ? null
                                                      : palette.surfaceLow,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            entry.$1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  fontWeight: value > 0
                                                      ? FontWeight.w700
                                                      : FontWeight.w500,
                                                  fontSize: 10,
                                                  color: value > 0
                                                      ? palette.text
                                                      : palette.textMuted,
                                                ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Recent Threads
                        if (sessions.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Intellectual Threads',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                Icon(Icons.history_rounded,
                                    size: 20, color: palette.textMuted),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...sessions.take(5).map((session) {
                            final dateStr = session.startedAt != null
                                ? DateFormat('MMM d, h:mm a')
                                    .format(session.startedAt!)
                                : 'Recent';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: palette.surfaceCard,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: palette.text.withValues(alpha: 0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: palette.primaryDim
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Icon(
                                      Icons.auto_awesome_rounded,
                                      color: palette.primaryDim,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: palette.surfaceLow,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                session.subject.toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color: palette.primaryDim,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 9,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              dateStr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: palette.textMuted,
                                                    fontSize: 11,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          session.topic ??
                                              'Exploration of ${session.subject}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                                letterSpacing: -0.3,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${session.attemptCount} Socratic Rounds',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: palette.textMuted,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: palette.textMuted,
                                    size: 16,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                    const SizedBox(height: 120), // Space for floating nav bar
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

  List<(String, double)> _weeklyHourChart(List<ApiSession> items) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final hourCounts = List<double>.filled(7, 0.0);

    for (final session in items) {
      final date = session.startedAt ?? session.createdAt;
      if (date == null) continue;
      final weekdayIndex = (date.weekday - 1).clamp(0, 6);
      hourCounts[weekdayIndex] += (session.duration ?? 0) / 3600;
    }

    return List.generate(
        labels.length, (index) => (labels[index], hourCounts[index]));
  }
}
