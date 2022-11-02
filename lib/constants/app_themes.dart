import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  ThemeData themeData = ThemeData(
    //COLORS
    colorScheme: const ColorScheme.light(
      primary: Color(0xff72479d),
      secondary: Color(0xfff19c79),
      background: Color(0xfff1ffe7),
      onPrimary: Color(0xfff1ffe7),
      onSecondary: Color(0xff0d0106),
      onBackground: Color(0xff0d0106),
      primaryContainer: Color(0xfff19c79),
      secondaryContainer: Color(0xff9fc490),
      //TODO fill necessary colors
    ),

    //TEXT
    fontFamily: GoogleFonts.nunito().fontFamily,
    textTheme: const TextTheme(
      headline3: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),

      //TODO fill text themes
    ),

    //TEXT FIELD
    inputDecorationTheme: const InputDecorationTheme(
        //TODO fill input decoration themes
        ),

    //BUTTONS
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(),
    ),
    //TODO fill button themes
    outlinedButtonTheme: const OutlinedButtonThemeData(
        style: ButtonStyle(
            //TODO fill button themes
            )),
    textButtonTheme: const TextButtonThemeData(
        style: ButtonStyle(
            //TODO fill button themes
            )),

    //OTHER
    //TODO fill other themes
  );
}
