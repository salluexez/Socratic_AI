import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subject.dart';
import '../services/subject_catalog.dart';

class CourseController extends ValueNotifier<List<String>> {
  CourseController(List<String> initialSlugs) : super(initialSlugs);

  static const String _coursesKey = 'selected_courses';

  List<Subject> get allSubjects => SubjectCatalog.subjects;

  List<Subject> get activeSubjects {
    return allSubjects.where((s) => s.isPermanent || value.contains(s.slug)).toList();
  }

  bool isSelected(String slug) {
    final s = allSubjects.firstWhere((element) => element.slug == slug);
    if (s.isPermanent) return true;
    return value.contains(slug);
  }

  Future<void> toggleCourse(String slug) async {
    final s = allSubjects.firstWhere((element) => element.slug == slug);
    if (s.isPermanent) return;

    final newList = List<String>.from(value);
    if (newList.contains(slug)) {
      newList.remove(slug);
    } else {
      newList.add(slug);
    }
    value = newList;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_coursesKey, value);
    } catch (e) {
      debugPrint('Error saving courses: $e');
    }
  }

  static Future<List<String>> getSavedCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_coursesKey) ?? [];
    } catch (e) {
      debugPrint('Error loading courses: $e');
      return [];
    }
  }
}

class CourseControllerScope extends InheritedWidget {
  const CourseControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final CourseController controller;

  static CourseController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CourseControllerScope>();
    assert(scope != null, 'CourseControllerScope not found in context');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(CourseControllerScope oldWidget) =>
      controller != oldWidget.controller;
}
