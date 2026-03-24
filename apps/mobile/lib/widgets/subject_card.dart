import 'package:flutter/material.dart';

import '../models/subject.dart';
import '../theme/app_theme.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.subject,
    required this.onTap,
  });

  final Subject subject;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: palette.surfaceCard,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.3) : palette.text.withValues(alpha: 0.05),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: subject.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(subject.icon, color: subject.accent, size: 24),
              ),
              const SizedBox(height: 18),
              if (subject.resumeLabel != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: subject.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    subject.resumeLabel!,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: subject.accent,
                        ),
                  ),
                ),
              Text(subject.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  subject.description,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: palette.textMuted,
                      ),
                ),
              ),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  Text(
                    'Resume session',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: subject.accent,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: subject.accent, size: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
