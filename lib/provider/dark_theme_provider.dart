import 'package:app_store/models/dark_theme_preferences.dart';
import 'package:flutter/material.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreferences darkThemePreferences = DarkThemePreferences();
  bool _darktheme = false;
  bool get darkTheme => _darktheme;

  set darkTheme(bool value) {
    _darktheme = value;
    darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }
}
