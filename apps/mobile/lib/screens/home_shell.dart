import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'learn_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import 'shared_screen.dart';
import '../widgets/ambient_background.dart';
import '../theme/theme_controller.dart';
import '../theme/app_theme.dart';

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
    SharedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => setState(() => currentIndex = 0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/logo.jpg',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Socratic-Ai',
                style: GoogleFonts.cookie(
                  fontSize: 32,
                  color: palette.primaryDim,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => ThemeControllerScope.of(context).next(),
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Switch Theme',
          ),
          GestureDetector(
            onTap: () => setState(() => currentIndex = 3),
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
      body: Stack(
        children: [
          const AmbientBackground(),
          IndexedStack(
            index: currentIndex,
            children: screens,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 80,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
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
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark 
                    ? palette.surfaceCard.withValues(alpha: 0.6) 
                    : palette.surfaceCard.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : palette.outline.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: _buildNavBar(palette),
              ),
            ),
          ),
        ),
      ),
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
          icon: Icon(Icons.people_outline_rounded),
          selectedIcon: Icon(Icons.people_rounded),
          label: 'Shared',
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
