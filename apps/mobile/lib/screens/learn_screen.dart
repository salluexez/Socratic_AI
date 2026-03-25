import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/subject.dart';
import '../services/app_config.dart';
import '../services/backend_api_service.dart';
import '../services/subject_catalog.dart';
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: palette.chipBackground,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Current Session',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: palette.primaryDim,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Where shall your curiosity lead today?',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: palette.text,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Select a subject and begin a guided conversation through questions, hints, and deeper thinking.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: palette.textMuted,
                  ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 360;
                final courseController = CourseControllerScope.of(context);
                
                return ValueListenableBuilder<List<String>>(
                  valueListenable: courseController,
                  builder: (context, selectedSlugs, _) {
                    final subjects = courseController.activeSubjects;
                    
                    return GridView.builder(
                      itemCount: subjects.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isCompact ? 1 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: isCompact ? 200 : 210,
                      ),
                      itemBuilder: (context, index) {
                        final subject = subjects[index];
                        return SubjectCard(
                          subject: subject,
                          onTap: () => _openChat(context, subject),
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: palette.surfaceCard,
                borderRadius: BorderRadius.circular(30),
                border: isDark ? Border.all(color: palette.outline, width: 1) : null,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withValues(alpha: 0.15) : palette.text.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Socratic Prompt of the Day',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: palette.primaryDim,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '"If you wish to converse with me, define your terms."',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Choose a path and connect ideas across subjects with calm, structured questioning.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: palette.textMuted,
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
