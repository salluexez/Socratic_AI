import 'package:flutter/material.dart';

class ThemeController extends ValueNotifier<int> {
  ThemeController() : super(0);

  void next() {
    value = (value + 1) % 6; // 6 total themes
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
