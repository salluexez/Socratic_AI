import 'package:flutter/material.dart';

import '../models/subject.dart';

class SubjectCatalog {
  static const subjects = <Subject>[
    Subject(
      slug: 'mathematics',
      name: 'Mathematics',
      description: 'The study of numbers, shapes, and patterns.',
      icon: Icons.functions,
      accent: Colors.blue,
      isPermanent: true,
    ),
    Subject(
      slug: 'physics',
      name: 'Physics',
      description: 'The study of matter, energy, and the universe.',
      icon: Icons.public,
      accent: Colors.purple,
      isPermanent: true,
    ),
    Subject(
      slug: 'chemistry',
      name: 'Chemistry',
      description: 'The study of substances and their reactions.',
      icon: Icons.science,
      accent: Colors.orange,
      isPermanent: true,
    ),
    Subject(
      slug: 'biology',
      name: 'Biology',
      description: 'The study of living organisms and life processes.',
      icon: Icons.psychology,
      accent: Colors.green,
      isPermanent: true,
    ),
    Subject(
      slug: 'computer-science',
      name: 'Computer Science',
      description: 'Computing system and software development.',
      icon: Icons.computer,
      accent: Colors.cyan,
    ),
    Subject(
      slug: 'history',
      name: 'History',
      description: 'The study of past events and civilizations.',
      icon: Icons.history_edu,
      accent: Colors.brown,
    ),
    Subject(
      slug: 'political-science',
      name: 'Political Science',
      description: 'Systems of government and political activity.',
      icon: Icons.gavel,
      accent: Colors.indigo,
    ),
    Subject(
      slug: 'economics',
      name: 'Economics',
      description: 'Production, consumption, and wealth transfer.',
      icon: Icons.trending_up,
      accent: Colors.teal,
    ),
    Subject(
      slug: 'literature',
      name: 'Literature',
      description: 'Creative writing and literary analysis.',
      icon: Icons.menu_book,
      accent: Colors.pink,
    ),
  ];
}
