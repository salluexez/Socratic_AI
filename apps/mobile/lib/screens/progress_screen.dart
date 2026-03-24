import 'package:flutter/material.dart';

import '../services/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Progress')),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      'You explored 12 complex domains this week. Keep following the questions.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: palette.textMuted,
                          ),
                    ),
                    const SizedBox(height: 18),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final stats =
                            MockDataService.progressStats.take(2).toList();
                        final shouldStack = constraints.maxWidth < 380;

                        if (shouldStack) {
                          return Column(
                            children: stats.map((stat) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: StatCard(
                                  title: stat.label,
                                  value: stat.value,
                                  subtitle: stat.detail,
                                  color: stat.label == 'Hours Spent'
                                      ? AppColors.primary
                                      : AppColors.secondary,
                                  compact: true,
                                ),
                              );
                            }).toList(),
                          );
                        }

                        return Row(
                          children: stats.asMap().entries.map((entry) {
                            final index = entry.key;
                            final stat = entry.value;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: index == stats.length - 1 ? 0 : 12,
                                ),
                                child: StatCard(
                                  title: stat.label,
                                  value: stat.value,
                                  subtitle: stat.detail,
                                  color: stat.label == 'Hours Spent'
                                      ? AppColors.primary
                                      : AppColors.secondary,
                                  compact: true,
                                ),
                              ),
                            );
                          }).toList(),
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
                    Text('Progress Chart',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Cognitive engagement over the last 7 days',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: palette.textMuted,
                          ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 220,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(
                            MockDataService.chartValues.length, (index) {
                          final value = MockDataService.chartValues[index];
                          final label = MockDataService.chartLabels[index];
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: 170 * value,
                                        decoration: BoxDecoration(
                                          color: index == 2
                                              ? AppColors.primary
                                              : AppColors.primary.withValues(
                                                  alpha: 0.25 + value / 2),
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(999),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: index == 2
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
                    const StatCard(
                      title: 'Topics Mastered',
                      value: '42',
                      subtitle: 'Deep understanding across subjects',
                      color: AppColors.secondary,
                    ),
                    const StatCard(
                      title: 'Learning Streak',
                      value: '14d',
                      subtitle: 'Consistent growth mindset',
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
}
