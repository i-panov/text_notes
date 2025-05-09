import 'package:flutter/material.dart';

class ThemeModeProvider extends ValueNotifier<ThemeMode> {
  ThemeModeProvider() : super(ThemeMode.light);

  void setThemeMode(ThemeMode mode) {
    value = mode;
  }

  void toggleThemeMode() {
    if (value == ThemeMode.light) {
      value = ThemeMode.dark;
    } else {
      value = ThemeMode.light;
    }
  }
}
