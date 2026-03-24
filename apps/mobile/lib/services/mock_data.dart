import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../models/session_summary.dart';
import '../models/subject.dart';
import '../theme/app_theme.dart';

class MockDataService {
  static const subjects = <Subject>[
    Subject(
      slug: 'math',
      name: 'Mathematics',
      description:
          'Explore calculus, algebra, geometry, and elegant reasoning.',
      icon: Icons.functions_rounded,
      accent: AppColors.primary,
      resumeLabel: 'Resume',
    ),
    Subject(
      slug: 'physics',
      name: 'Physics',
      description:
          'Understand force, motion, waves, and the laws of the universe.',
      icon: Icons.architecture_rounded,
      accent: AppColors.tertiary,
    ),
    Subject(
      slug: 'chemistry',
      name: 'Chemistry',
      description: 'Study atoms, reactions, bonding, and matter in motion.',
      icon: Icons.science_rounded,
      accent: AppColors.secondary,
    ),
    Subject(
      slug: 'biology',
      name: 'Biology',
      description: 'Learn cells, systems, genetics, and living ecosystems.',
      icon: Icons.biotech_rounded,
      accent: Color(0xFF1E8E5A),
    ),
  ];

  static List<ChatMessage> starterConversation(String subjectName) => [
        ChatMessage(
          role: 'assistant',
          content:
              'Let us explore $subjectName together. What do you already understand about the problem you are solving?',
        ),
        const ChatMessage(
          role: 'user',
          content:
              'I think the object keeps moving because it already has horizontal velocity.',
        ),
        const ChatMessage(
          role: 'assistant',
          content:
              'That is a strong start. If the object already has horizontal motion, what force would need to act on it to suddenly stop that motion?',
          isHint: true,
        ),
      ];

  static const progressStats = <SessionSummary>[
    SessionSummary(
      label: 'Hours Spent',
      value: '14.5',
      detail: 'Focused learning this week',
    ),
    SessionSummary(
      label: 'Focus Score',
      value: '88%',
      detail: 'Strong consistency across sessions',
    ),
    SessionSummary(
      label: 'Topics Mastered',
      value: '42',
      detail: 'Deep understanding across subjects',
    ),
  ];

  static const chartValues = <double>[0.4, 0.65, 0.9, 0.55, 0.75, 0.3, 0.2];
  static const chartLabels = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];
}
