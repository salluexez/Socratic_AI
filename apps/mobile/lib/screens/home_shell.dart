import 'package:flutter/material.dart';

import 'learn_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import '../theme/theme_controller.dart';
import '../theme/app_theme.dart';
import '../services/app_config.dart';

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
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeController = ThemeControllerScope.of(context);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(
          AppConfig.appName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () => themeController.next(),
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: palette.textMuted,
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => currentIndex = 2),
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 8),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: palette.chipBackground,
                child: Icon(Icons.person_rounded, 
                  size: 20,
                  color: isDark ? Colors.white : palette.primaryDim),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: screens[currentIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 80,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          decoration: BoxDecoration(
            color: isDark 
              ? palette.surfaceCard.withValues(alpha: 0.8) 
              : palette.surfaceCard.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(32),
            border: isDark ? Border.all(color: palette.outline, width: 1) : null,
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.2) : palette.text.withValues(alpha: 0.1),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: isDark 
              ? BackdropFilter(
                  filter: ColorFilter.mode(palette.surfaceCard.withValues(alpha: 0.1), BlendMode.overlay),
                  child: _buildNavBar(palette),
                )
              : _buildNavBar(palette),
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: isDark ? [
            BoxShadow(
              color: palette.primaryDim.withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ] : [],
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Future: Start new session
          },
          backgroundColor: palette.primaryDim,
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          elevation: isDark ? 0 : 10,
          child: const Icon(Icons.bolt_rounded, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildNavBar(AppPalette palette) {
    return NavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      height: 80,
      selectedIndex: currentIndex,
      onDestinationSelected: (index) =>
          setState(() => currentIndex = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school_rounded),
          label: 'Learn',
        ),
        NavigationDestination(
          icon: Icon(Icons.insights_rounded),
          selectedIcon: Icon(Icons.insights_rounded),
          label: 'Progress',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
