import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/theme_provider.dart';

import '../constants/app_themes.dart';

class ThemeButton extends StatelessWidget {
  var _darkTheme = true;

  ThemeButton({super.key});

  void onThemeChanged(bool value, ThemeProvider themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(AppThemes().lightTheme)
        : themeNotifier.setTheme(AppThemes().darkTheme);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    _darkTheme = (themeNotifier.currentTheme == AppThemes().darkTheme);
    return TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Provider.of<ThemeProvider>(context)
                .currentTheme
                .colorScheme
                .primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )),
        onPressed: () {
          onThemeChanged(_darkTheme, themeNotifier);
        },
        child: Text(
          'Change Theme',
          style: TextStyle(
            color: Provider.of<ThemeProvider>(context)
                .currentTheme
                .colorScheme
                .onPrimary,
          ),
        ));
  }
}
