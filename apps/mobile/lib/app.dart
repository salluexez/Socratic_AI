import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'services/app_config.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

class SocraticAiApp extends StatefulWidget {
  const SocraticAiApp({super.key});

  @override
  State<SocraticAiApp> createState() => _SocraticAiAppState();
}

class _SocraticAiAppState extends State<SocraticAiApp> {
  final themeController = ThemeController();

  @override
  void dispose() {
    themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeControllerScope(
      controller: themeController,
      child: ValueListenableBuilder<int>(
        valueListenable: themeController,
        builder: (context, themeIndex, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConfig.appName,
            theme: AppTheme.themes[themeIndex],
            themeMode: ThemeMode.light, // We use manual theme selection
            initialRoute: OnboardingScreen.routeName,
            routes: {
              OnboardingScreen.routeName: (_) => const OnboardingScreen(),
              AuthScreen.routeName: (_) => const AuthScreen(),
              HomeShell.routeName: (_) => const HomeShell(),
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
    );
  }
}
