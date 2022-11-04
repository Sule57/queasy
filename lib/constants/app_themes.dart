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

      //TODO fill necessary colors
    ),

    //TEXT
    fontFamily: GoogleFonts.nunito().fontFamily,
    textTheme: TextTheme(
      headline3: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      caption: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: purple,
      ),

      //TODO fill text themes
    ),

    //TEXT FIELD
    inputDecorationTheme: const InputDecorationTheme(
        //TODO fill input decoration themes
        ),

    //BUTTONS
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(TextStyle(fontSize: 40)),
      ),
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
