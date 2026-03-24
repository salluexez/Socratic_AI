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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: palette.surfaceCard,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: subject.accent.withValues(alpha: 0.08),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: subject.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(subject.icon, color: subject.accent, size: 30),
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
              const SizedBox(height: 18),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  Text(
                    'Begin inquiry',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: subject.accent,
                        ),
                  ),
                  Icon(Icons.arrow_forward_rounded, color: subject.accent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
