import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'screens/all_sessions_screen.dart';
import 'screens/explore_courses_screen.dart';
import 'services/app_config.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';
import 'controllers/course_controller.dart';

class SocraticAiApp extends StatefulWidget {
  final int initialThemeIndex;
  final List<String> initialCourses;
  
  const SocraticAiApp({
    super.key, 
    this.initialThemeIndex = 0,
    this.initialCourses = const [],
  });

  @override
  State<SocraticAiApp> createState() => _SocraticAiAppState();
}

class _SocraticAiAppState extends State<SocraticAiApp> {
  late final ThemeController themeController;
  late final CourseController courseController;

  @override
  void initState() {
    super.initState();
    themeController = ThemeController(widget.initialThemeIndex);
    courseController = CourseController(widget.initialCourses);
  }

  @override
  void dispose() {
    themeController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CourseControllerScope(
      controller: courseController,
      child: ThemeControllerScope(
        controller: themeController,
        child: ValueListenableBuilder<int>(
          valueListenable: themeController,
          builder: (context, themeIndex, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppConfig.appName,
              theme: AppTheme.themes[themeIndex],
              themeMode: ThemeMode.light, // We use manual theme selection
              initialRoute: SplashScreen.routeName,
              routes: {
                SplashScreen.routeName: (_) => const SplashScreen(),
                OnboardingScreen.routeName: (_) => const OnboardingScreen(),
                AuthScreen.routeName: (_) => const AuthScreen(),
                HomeShell.routeName: (_) => const HomeShell(),
                AllSessionsScreen.routeName: (_) => const AllSessionsScreen(),
                ExploreCoursesScreen.routeName: (_) => const ExploreCoursesScreen(),
              },
              onGenerateRoute: (settings) {
                if (settings.name == ChatScreen.routeName) {
                  final args = settings.arguments as ChatScreenArgs;
                  return MaterialPageRoute(
                    builder: (_) => ChatScreen(args: args),
                  );
                }
                return null;
              },
            );
          },
        ),
      ),
    );
  }
}
