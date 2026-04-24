import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/subject.dart';
import '../theme/app_theme.dart';
import '../widgets/subject_card.dart';
import '../controllers/course_controller.dart';
import 'chat_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String? loadingSubject;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: palette.primaryDim.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'CURRENT SESSION',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: palette.primaryDim,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Explore your ',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: palette.textMuted,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Curiosity',
                  style: GoogleFonts.cookie(
                    fontSize: 28,
                    color: palette.primaryDim,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Select a subject and begin a guided conversation through questions, hints, and deeper thinking.',
              style: GoogleFonts.inter(
                    color: palette.text,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                // Ensure 2 columns on most phones by lowering threshold
                final isCompact = constraints.maxWidth < 280;
                final courseController = CourseControllerScope.of(context);
                
                return ValueListenableBuilder<List<String>>(
                  valueListenable: courseController,
                  builder: (context, selectedSlugs, _) {
                    final subjects = courseController.activeSubjects;
                    
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final spacing = 12.0;
                        final width = (constraints.maxWidth - spacing) / (isCompact ? 1 : 2);
                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: subjects.map((subject) {
                            return SizedBox(
                              width: width,
                              child: SubjectCard(
                                subject: subject,
                                onTap: () => _openChat(context, subject),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: palette.surfaceCard,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: palette.outline.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark 
                        ? Colors.black.withValues(alpha: 0.2) 
                        : palette.text.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: palette.primaryDim.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Socratic Prompt of the Day',
                      style: GoogleFonts.inter(
                            color: palette.primaryDim,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '"If you wish to converse with me, define your terms."',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Choose a path and connect ideas across subjects with calm, structured questioning.',
                    style: GoogleFonts.inter(
                          color: palette.textMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat(BuildContext context, Subject subject) {
    Navigator.pushNamed(
      context,
      ChatScreen.routeName,
      arguments: ChatScreenArgs(subject: subject, sessionId: null),
    );
  }
}
