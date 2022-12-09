import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  get currentTheme => _themeData;

  setTheme(ThemeData newTheme) async {
    _themeData = newTheme;
    notifyListeners();
  }
}
