import 'package:flutter/material.dart';

import '../models/subject.dart';
import '../services/mock_data.dart';
import '../theme/app_theme.dart';
import '../widgets/subject_card.dart';
import 'chat_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethereal Mentor'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: palette.chipBackground,
              child: const Icon(Icons.person_rounded, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SafeArea(
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
                        color: AppColors.primary,
                      ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Where shall your curiosity lead today?',
                style: Theme.of(context).textTheme.displayMedium,
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
                  return GridView.builder(
                    itemCount: MockDataService.subjects.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isCompact ? 1 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: isCompact ? 240 : 260,
                    ),
                    itemBuilder: (context, index) {
                      final subject = MockDataService.subjects[index];
                      return SubjectCard(
                        subject: subject,
                        onTap: () => _openChat(context, subject),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: palette.surfaceLow,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Socratic Prompt of the Day',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppColors.primary,
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
      ),
    );
  }

  void _openChat(BuildContext context, Subject subject) {
    Navigator.pushNamed(
      context,
      ChatScreen.routeName,
      arguments: ChatScreenArgs(subject: subject),
    );
  }
}
