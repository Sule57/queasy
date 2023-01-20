/// ****************************************************************************
/// Created by Julia Agüero
/// Collaborator: Endia Clark
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// DO NOT USE THESE COLORS IN YOUR CODE. USE THE THEME INSTEAD.
//
// These colors are used to have consistency through the colors of the theme,
// so later it's easier for us to change them. If you want to use one of
// these colors, you should use Theme.of(context).colorScheme...
Color orange = const Color(0xfff19c79);
Color green = const Color(0xff9fc490);
Color purple = const Color(0xff72479d);
Color light = const Color(0xfff1ffe7);
Color dark = const Color(0xff0d0106);

/// Defines the themes of the app.
///
/// The app has two themes: light and dark. The light theme is the default theme.
/// The dark theme is used when the user enables dark mode in the app settings.
class AppThemes {
  /// Default theme of the app, taken by the app if user has selects the light
  /// theme.
  ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: purple,
      onPrimary: Colors.white,
      secondary: orange,
      onSecondary: dark,
      tertiary: green,
      onTertiary: light,
      background: Colors.white,
      onBackground: dark,
    ),
    fontFamily: GoogleFonts.nunito().fontFamily,
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      headline1: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: dark,
      ),
      headline2: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: dark,
      ),
      headline3: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: dark,
      ),
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: dark,
      ),
      headline5: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: dark,
      ),
      headline6: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: dark,
      ),
      subtitle1: TextStyle(
        fontSize: 24,
        color: dark,
      ),
      subtitle2: TextStyle(
        fontSize: 16,
        color: dark,
      ),
      bodyText1: TextStyle(
        fontSize: 12,
        color: dark,
      ),
      bodyText2: TextStyle(
        fontSize: 10,
        color: dark,
      ),
      button: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: dark,
      ),
      caption: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      counterStyle: TextStyle(fontSize: 16),
    ),
  );

  /// Theme taken by the app if user has selects the dark theme.
  ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: const Color(0xff57456e),
      onPrimary: Colors.white,
      secondary: const Color(0xff945438),
      onSecondary: dark,
      tertiary: green,
      onTertiary: const Color(0xff3F4B3B),
      background: Colors.black87,
      onBackground: Colors.white,
    ),
    fontFamily: GoogleFonts.nunito().fontFamily,
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      headline1: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline2: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline3: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline4: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline5: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headline6: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      subtitle1: TextStyle(
        fontSize: 24,
        color: Colors.white,
      ),
      subtitle2: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyText1: TextStyle(
        fontSize: 12,
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        fontSize: 10,
        color: Colors.white,
      ),
      button: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      caption: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: purple,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      counterStyle: TextStyle(fontSize: 16),
    ),
  );
}
