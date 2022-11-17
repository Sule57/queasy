import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color orange = const Color(0xfff19c79);
Color green = const Color(0xff9fc490);
Color purple = const Color(0xff72479d);
Color white = const Color(0xfff1ffe7);
Color black = const Color(0xff0d0106);

class AppThemes {
  ThemeData themeData = ThemeData(
    //COLOR
    colorScheme: ColorScheme.light(
      primary: purple,
      onPrimary: white,
      secondary: orange,
      onSecondary: black,
      tertiary: green,
      onTertiary: black,
      background: white,
      onBackground: black,
    ),

    //TEXT
    fontFamily: GoogleFonts.nunito().fontFamily,
    textTheme: TextTheme(
      headline3: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: black,
      ),
      headline2: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: white,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        color: black,
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        color: black,
      ),
      caption: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: purple,
      ),
    ),

    //TEXT FIELD
    inputDecorationTheme: const InputDecorationTheme(
      counterStyle: TextStyle(fontSize: 16.0),
    ),

    //BUTTONS

    //OTHER
  );
}
