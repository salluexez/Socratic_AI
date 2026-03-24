import 'package:flutter/material.dart';

import '../models/subject.dart';
import '../theme/app_theme.dart';

class SubjectCatalog {
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
}
