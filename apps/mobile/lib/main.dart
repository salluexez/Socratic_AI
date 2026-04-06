import 'package:flutter/material.dart';
import 'theme/theme_controller.dart';
import 'controllers/course_controller.dart';
import 'services/backend_api_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await BackendApiService.instance.init();
  
  final initialThemeIndex = await ThemeController.getSavedTheme();
  final initialCourses = await CourseController.getSavedCourses();
  
  runApp(SocraticAiApp(
    initialThemeIndex: initialThemeIndex,
    initialCourses: initialCourses,
  ));
}
