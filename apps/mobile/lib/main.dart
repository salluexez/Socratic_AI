import 'package:flutter/material.dart';
import 'theme/theme_controller.dart';
import 'controllers/course_controller.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final initialThemeIndex = await ThemeController.getSavedTheme();
  final initialCourses = await CourseController.getSavedCourses();
  
  runApp(SocraticAiApp(
    initialThemeIndex: initialThemeIndex,
    initialCourses: initialCourses,
  ));
}
