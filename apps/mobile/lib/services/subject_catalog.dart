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
      accent: Color(0xFF3B82F6), // Blue
      resumeLabel: 'Resume',
    ),
    Subject(
      slug: 'physics',
      name: 'Physics',
      description:
          'Understand force, motion, waves, and the laws of the universe.',
      icon: Icons.architecture_rounded,
      accent: Color(0xFFF59E0B), // Amber
    ),
    Subject(
      slug: 'chemistry',
      name: 'Chemistry',
      description: 'Study atoms, reactions, bonding, and matter in motion.',
      icon: Icons.science_rounded,
      accent: Color(0xFF6366F1), // Indigo
    ),
    Subject(
      slug: 'biology',
      name: 'Biology',
      description: 'Learn cells, systems, genetics, and living ecosystems.',
      icon: Icons.biotech_rounded,
      accent: Color(0xFF10B981), // Emerald
    ),
  ];
}
