import 'package:flutter/material.dart';

class Subject {
  const Subject({
    required this.slug,
    required this.name,
    required this.description,
    required this.icon,
    required this.accent,
    this.resumeLabel,
  });

  final String slug;
  final String name;
  final String description;
  final IconData icon;
  final Color accent;
  final String? resumeLabel;
}
