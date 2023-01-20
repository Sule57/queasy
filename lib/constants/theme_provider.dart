import 'package:flutter/material.dart';
import 'package:queasy/constants/app_themes.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = AppThemes().lightTheme;

  ThemeProvider(this._themeData);

  get currentTheme => _themeData;

  setTheme(ThemeData newTheme) async {
    _themeData = newTheme;
    notifyListeners();
  }
}
