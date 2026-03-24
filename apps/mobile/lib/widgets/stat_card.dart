import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.compact = false,
  });

  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(compact ? 20 : 24),
      decoration: BoxDecoration(
        color: palette.surfaceCard,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.3) : palette.text.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: compact ? 24 : 32,
              fontWeight: FontWeight.w700,
              color: palette.text,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: palette.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 11,
                  color: palette.textMuted,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
