import 'package:flutter/material.dart';

import 'learn_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import '../theme/theme_controller.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  static const routeName = '/home';

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int currentIndex = 0;

  final screens = const [
    LearnScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeControllerScope.of(context);

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => setState(() => currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.insert_chart_outlined_rounded),
            selectedIcon: Icon(Icons.insert_chart_rounded),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: themeController.toggle,
        child: Icon(
          themeController.value == ThemeMode.dark
              ? Icons.light_mode_rounded
              : Icons.dark_mode_rounded,
        ),
      ),
    );
  }
}
