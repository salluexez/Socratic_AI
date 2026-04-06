import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ValueNotifier<int> {
  ThemeController(super.initialIndex);

  static const String _themeKey = 'theme_index';

  Future<void> next() async {
    final nextIndex = (value + 1) % 10; // 10 total themes
    value = nextIndex;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, nextIndex);
    } catch (_) {
      debugPrint('Error saving theme: $_');
    }
  }
  
  static Future<int> getSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_themeKey) ?? 0;
    } catch (_) {
      debugPrint('Error loading theme: $_');
      return 0;
    }
  }
}

class ThemeControllerScope extends InheritedWidget {
  const ThemeControllerScope({
    super.key,
    required this.controller,
    required super.child,
  });

  final ThemeController controller;

  static ThemeController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ThemeControllerScope>();
    assert(scope != null, 'ThemeControllerScope not found in context');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(ThemeControllerScope oldWidget) =>
      controller != oldWidget.controller;
}
