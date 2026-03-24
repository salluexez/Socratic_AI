import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      body: Stack(
        children: [
          const _AmbientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: palette.surfaceCard,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: palette.primaryDim.withValues(alpha: 0.08),
                          blurRadius: 36,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Transform.rotate(
                            angle: 0.08,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    palette.primaryContainer,
                                    palette.tertiaryContainer,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Text(
                                '"What would happen if we changed the variable?"',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: palette.text,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          height: 280,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                palette.heroBackground,
                                palette.surfaceCard,
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 120,
                                  color: palette.primaryDim,
                                ),
                              ),
                              Positioned(
                                left: 18,
                                bottom: 18,
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: palette.surfaceCard.withValues(
                                      alpha: 0.72,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: palette.primaryDim,
                                        child: const Icon(
                                          Icons.lightbulb_rounded,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text('Critical Thinking +12'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Learn by Thinking',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'AI that guides you with questions, hints, and step-by-step reasoning instead of instant answers.',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: palette.textMuted,
                                  ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _FeatureChip(
                                icon: Icons.psychology_alt_rounded,
                                label: 'Socratic Method'),
                            _FeatureChip(
                                icon: Icons.auto_awesome_rounded,
                                label: 'Active Recall'),
                            _FeatureChip(
                                icon: Icons.school_rounded,
                                label: 'Guided Learning'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    label: 'Get Started',
                    onPressed: () =>
                        Navigator.pushNamed(context, AuthScreen.routeName),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AuthScreen.routeName),
                    child: const Text('Already have an account? Sign In'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: context.palette.surfaceLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: context.palette.primaryDim),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -70,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.palette.orbTop,
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.palette.orbBottom,
            ),
          ),
        ),
      ],
    );
  }
}
