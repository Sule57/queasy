/// ****************************************************************************
/// Created by Endia Clark
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/theme_provider.dart';

import '../../../../constants/app_themes.dart';

/// The widget [ThemeButton] is used to switch the app theme between light and dark themes.
class ThemeButton extends StatelessWidget {
  /// The [_darkTheme] parameter stores whether the app is current set as dark theme.
  /// It is initializes as true, but is updated later while the Widget is built.
  var _darkTheme = true;

  ThemeButton({super.key});

  ///When called, it takes the given boolean [value] and updates the [ThemeProvider].
  ///If true, the [ThemeProvider] is set to the light theme.
  ///If false, the [ThemeProvider] is set to the dark theme.
  void onThemeChanged(bool value, ThemeProvider themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(AppThemes().lightTheme)
        : themeNotifier.setTheme(AppThemes().darkTheme);
  }

  /// Builds the [ThemeButton] Widget.
  ///
  /// Uses an [ElevatedButton] as a base and calls [onThemeChanged] when pressed.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    _darkTheme = (themeNotifier.currentTheme == AppThemes().darkTheme);
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: themeNotifier.currentTheme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )),
        onPressed: () {
          onThemeChanged(_darkTheme, themeNotifier);
        },
        child: Text(
          'Change Theme',
          style: TextStyle(
            color: Colors.white,
          ),
        ));
  }
}
