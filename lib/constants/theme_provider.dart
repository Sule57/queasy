/// ****************************************************************************
/// Created by Endia Clark
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************
import 'package:flutter/material.dart';
import 'package:queasy/constants/app_themes.dart';

///This is a class that manages the current app theme.
///
///The [_themeData] parameter stores the current app theme.
///It is initialized to be the light theme in [AppThemes].
class ThemeProvider with ChangeNotifier {
  ///The [_themeData] parameter stores the current app theme.
  ///It is initialized to be the light theme in [AppThemes].
  ThemeData _themeData = AppThemes().lightTheme;

  ThemeProvider(this._themeData);

  ///getter method for the current theme data
  get currentTheme => _themeData;

  ///Takes a [newTheme] and sets the [_themeData] parameter to it.
  ///It also updates any [_themeData] listeners so they are updated.
  setTheme(ThemeData newTheme) async {
    _themeData = newTheme;
    notifyListeners();
  }
}
