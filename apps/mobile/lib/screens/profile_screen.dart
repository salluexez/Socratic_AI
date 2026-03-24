import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      child: const Icon(Icons.person_rounded,
                          size: 44, color: AppColors.primary),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alex Chen',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 6),
                          Text(
                            'Synthesizing knowledge across 128 sessions',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: palette.textMuted,
                                ),
                          ),
                          const SizedBox(height: 12),
                          const Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _Badge(
                                label: 'Mathematics Enthusiast',
                                color: Color(0xFFC0ADFF),
                              ),
                              _Badge(
                                label: 'Physics Explorer',
                                color: Color(0xFFDBF5F4),
                              ),
                            ],
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
                  const first = StatCard(
                    title: 'Current Accuracy',
                    value: '94%',
                    subtitle: 'Top 2% of Socratic peers',
                    color: AppColors.primary,
                    compact: true,
                  );
                  const second = StatCard(
                    title: 'Learning Streak',
                    value: '14d',
                    subtitle: 'Consistent growth mindset',
                    color: AppColors.tertiary,
                    compact: true,
                  );

                  if (constraints.maxWidth < 380) {
                    return const Column(
                      children: [
                        first,
                        SizedBox(height: 16),
                        second,
                      ],
                    );
                  }

                  return const Row(
                    children: [
                      Expanded(child: first),
                      SizedBox(width: 16),
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
                      palette.tertiaryContainer.withValues(alpha: 0.26),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.format_quote_rounded,
                        color: AppColors.primary, size: 36),
                    const SizedBox(height: 12),
                    Text(
                      '"Your synthesis of quantum field theory showed remarkable depth. The question is often more important than the answer."',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The Ethereal Mentor',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _ActionTile(
                icon: Icons.edit_rounded,
                title: 'Edit Name',
                subtitle: 'Update the identity shown across your sessions.',
              ),
              const SizedBox(height: 12),
              const _ActionTile(
                icon: Icons.lock_reset_rounded,
                title: 'Change Password',
                subtitle: 'Secure your account before demo time.',
              ),
              const SizedBox(height: 12),
              const _ActionTile(
                icon: Icons.logout_rounded,
                title: 'Log Out',
                subtitle: 'Return to the onboarding flow.',
              ),
            ],
          ),
        ),
      ),
    );
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: palette.textMuted,
                      ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: palette.textMuted),
        ],
      ),
    );
  }
}
